require 'rss'
require 'open-uri'

class FeedsController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]

  def create
    feed = Feed.find_by(url: params[:feed][:url])
    feed = Feed.new(feed_params) if feed.nil?
    feed.user << current_user
    if feed.save
      render json: feed, status: :created
    else
      render json: { errors: feed.errors }, status: :unprocessable_entity
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
  end
end
