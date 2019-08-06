require 'rss'
require 'open-uri'

class FeedsController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]

  def show
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feeds = current_user.feeds
    if feeds
      respond_with feeds
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  end

  def create
    feed = Feed.find_by(url: params[:feed][:url]) || Feed.new(feed_params)
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    if feed.users.any? { |a_user| a_user.id == current_user.id }
      return render json: { errors: "you are already subscribed to this feed" }, status: :unprocessable_entity
    end
    feed.users << current_user
    if feed.save
      render json: feed, status: :created
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  rescue CustomExceptions::BadRss => ex
    render json: { errors: ex.message }, status: ex.status
  end

  def destroy
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feed = current_user.feeds.find(params[:id])
    current_user.feeds.delete(feed)
    articles_deleted = []
    if feed.users.length == 0
      articles_deleted = feed.articles.destroy_all
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
