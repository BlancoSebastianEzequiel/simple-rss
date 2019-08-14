class ArticleFetcher

  def self.fetch(feed, current_user)
    articles = []
    get_articles(feed.url, feed.id).each do |article_data|
      article = Article.where(:link => article_data[:link]).first_or_create(article_data)
      article.users << current_user unless article.users.include? current_user
      unless article.update(article_data)
        raise StandardError.new(article.errors.as_json)
      end
      articles << article
    end
    articles
  end

  private

  def self.get_articles(url, feed_id)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      articles = []
      feed.items.each do |item|
        articles << {
            feed_id: feed_id,
            link: item.link,
            title: item.title,
            description: item.description,
            avatar: item.enclosure.url
        }
      end
      articles
    end
  end
end