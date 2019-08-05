require 'rss'
require 'open-uri'

class ArticlesController < ApplicationController

  respond_to :json
  wrap_parameters :feed, include: %i[feed_id]

  def update
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feed_id = article_params[:feed_id]
    feed = Feed.find_by(id: feed_id)
    return render json: { errors: "feed #{feed_id} does not exist" }, status: :unprocessable_entity unless feed
    articles = []
    get_articles(feed.url, feed.id).each do |article_data|
      article = Article.where(:link => article_data[:link]).first_or_create(article_data)
      unless article.update(article_data)
        return render json: { errors: article.errors }, status: :unprocessable_entity
      end
      articles << article
    end
    render json: articles, status: :ok
  rescue CustomExceptions::BadParams => ex
    render json: { errors: ex.message }, status: ex.status
  end

  def show
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feed = Feed.find_by(id: params[:feed_id])
    if feed.users.all? { |a_user| a_user.id != current_user.id }
      return render json: { errors: "you are not subscribed to this feed" }, status: :unprocessable_entity
    end
    respond_with feed.articles
  rescue StandardError => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  private

  def article_params
    required_params = params.require(:article).permit(:feed_id)
    raise CustomExceptions::BadParams.new("no feed id") if required_params.empty?
    required_params
  end

  def get_articles(url, feed_id)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      articles = []
      feed.items.each do |item|
        articles << { feed_id: feed_id, link: item.link, title: item.title }
      end
      articles
    end
  end
end
