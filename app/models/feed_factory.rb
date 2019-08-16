require 'rss'
require 'open-uri'

class FeedFactory
  def self.create(current_user, url)
    feed = Feed.find_by(url: url) || Feed.new(feed_params(url))
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
  rescue CustomExceptions::BadRssParse => ex
    Feed.find_by(url: url).delete
    { json: { errors: { url: ex.message } }, status: ex.status }
  end

  private

  def self.feed_params(url)
    parsed_params = { url: url }
    return parsed_params unless parsed_params[:url] =~ URI::regexp
    open(parsed_params[:url]) do |rss|
      feed = RSS::Parser.parse(rss)
      parsed_params[:title] = title(feed)
      parsed_params
    end
  rescue
    raise CustomExceptions::BadRss.new("your url rss is not valid")
  end

  def self.title(feed)
    return feed.channel.title if feed.class.method_defined?(:channel)
    feed.title
  end
end