require 'rss'
require 'open-uri'

class FeedFactory
  def self.create(current_user, params)
    feed = Feed.find_by(url: params[:feed][:url]) || Feed.new(feed_params(params))
    if feed.users.any? { |a_user| a_user.id == current_user.id }
      return { json: { errors: { url: "you are already subscribed to this feed" } } , status: :unprocessable_entity }
    end
    feed.users << current_user
    if feed.save
      ArticleFetcher.fetch(feed, current_user)
      { json: feed, status: :created }
    else
      { json: { errors: feed.errors }, status: :unprocessable_entity }
    end
  rescue CustomExceptions::BadRss => ex
    { json: { errors: { url: ex.message } }, status: ex.status }
  end

  private

  def self.feed_params(params)
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