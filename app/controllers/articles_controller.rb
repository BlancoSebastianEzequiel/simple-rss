require 'rss'
require 'open-uri'

class ArticlesController < ApplicationController

  respond_to :json
  wrap_parameters :feed, include: %i[feed_id]
  before_action :authenticate_with_token!, :only => [:show, :update]

  def update
    feed_id = article_params[:feed_id]
    feed = Feed.find_by(id: feed_id)
    return render json: { errors: "feed #{feed_id} does not exist" }, status: :unprocessable_entity unless feed
    articles = []
    get_articles(feed.url, feed.id).each do |article_data|
      article = Article.where(:link => article_data[:link]).first_or_create(article_data)
      article.users << current_user unless article.users.include? current_user
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
    feed = Feed.find_by(id: params[:feed_id])
    if feed.users.all? { |a_user| a_user.id != current_user.id }
      return render json: { errors: "you are not subscribed to this feed" }, status: :unprocessable_entity
    end
    articles = feed.articles.includes(:users).where(users: { id: current_user} ).references(:users)
    articles = articles.sort_by(&:updated_at).reverse.take(10)
    mapped_articles = []
    articles.each do |article|
      mapped_articles << { article: article, read: ArticlesUser.where(article: article, user: current_user)[0][:read] }
    end
    render json: mapped_articles, status: :ok
  rescue StandardError => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  def read
    data = params[:data]
    data.each do |article_data|
      article = Article.find_by(id: article_data[:article_id])
      article_user_rel = ArticlesUser.where(article: article, user: current_user)
      unless article_user_rel.update_all(:read => article_data[:read])
        render json: { errors: article_user_rel.errors }, status: :unprocessable_entity
      end
    end
    head :ok
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
