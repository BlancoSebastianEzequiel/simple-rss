require 'rss'
require 'open-uri'

class FeedsController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:show, :create, :destroy]

  def show
    feeds = current_user.feeds
    if feeds
      respond_with feeds
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  end

  def create
    feed = Feed.find_by(url: params[:feed][:url]) || Feed.new(feed_params)
    if feed.users.any? { |a_user| a_user.id == current_user.id }
      return render json: { errors: {url: "you are already subscribed to this feed" } }, status: :unprocessable_entity
    end
    feed.users << current_user
    if feed.save
      ArticleFetcher.fetch(feed, current_user)
      render json: feed, status: :created
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  rescue CustomExceptions::BadRss => ex
    render json: { errors: ex.message }, status: ex.status
  end

  def destroy
    # Esta query necesita ser refactorizada en otro branch ya que se necesita borrar la asociacion entre el articulo
    # y el ususario. Y en caso de que el articulo no tenga mas ususarios, borrar el articulo. Y finalmente, borrar
    # el feed si no tiene mas usuarios. La idea es refactorizar de manera de hacerlo en una sola query y agregar un
    # delete on cascade para evitar borrar relaciones a mano.
    feed = current_user.feeds.find(params[:id])
    current_user.feeds.delete(feed)
    feed.users.delete(current_user)
    articles_deleted = []
    feed.articles.each do |article|
      current_user.articles.delete(article)
      article.users.delete(current_user)
      if article.users.length == 0
        articles_deleted << article
        article.delete
      end
    end
    if feed.users.length == 0
      feed.delete
      render json: { feed:  feed, articles_deleted: articles_deleted }, status: :no_content
    else
      render json: { feed:  feed, articles_deleted: articles_deleted }, status: :ok
    end
  end

  private

  def feed_params
    parsed_params = params.require(:feed).permit(:url)
    return parsed_params unless parsed_params[:url] =~ URI::regexp
    open(parsed_params[:url]) do |rss|
      feed = RSS::Parser.parse(rss)
      parsed_params[:title] = feed.channel.title
      parsed_params
    end
  rescue
    raise CustomExceptions::BadRss.new("your url rss is not valid")
  end
end
