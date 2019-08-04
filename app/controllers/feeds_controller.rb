require 'rss'
require 'open-uri'

class FeedsController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]

  def show
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feeds = User.find_by(id: current_user.id).feed
    if feeds
      respond_with feeds
      # render json: feeds, status: :ok
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  rescue Exception => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  def create
    feed = Feed.find_by(url: params[:feed][:url])
    feed = Feed.new(feed_params) if feed.nil?
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feed.user << current_user
    if feed.save
      render json: feed, status: :created
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.feed.find(params[:id]).delete
    head 	:no_content
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
  end
end
