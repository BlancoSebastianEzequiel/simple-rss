require 'rss'
require 'open-uri'

class ArticlesController < ApplicationController

  respond_to :json
  wrap_parameters :feed, include: %i[feed_id]
  before_action :authenticate_with_token!, :only => [:show, :update, :read]

  def update
    feed_id = article_params[:feed_id]
    feed = Feed.find_by(id: feed_id)
    return render json: { errors: "feed #{feed_id} does not exist" }, status: :unprocessable_entity unless feed
    articles = ArticleFetcher.fetch(feed, current_user)
    render json: articles, status: :ok
  rescue CustomExceptions::BadParams => ex
    render json: { errors: ex.message }, status: ex.status
  rescue StandardError => ex
    render json: { errors: ex.message }, status: :unprocessable_entity
  end

  def show
    feed = Feed.find_by(id: params[:feed_id])
    if feed.users.all? { |a_user| a_user.id != current_user.id }
      return render json: { errors: "you are not subscribed to this feed" }, status: :unprocessable_entity
    end
    articles = feed.articles.includes(:users).where(users: { id: current_user} ).references(:users)
    number_of_articles = articles.length
    articles = articles.sort_by(&:updated_at).reverse.take(10)
    mapped_articles = []
    articles.each do |article|
      read = ArticlesUser.where(article: article, user: current_user).first[:read]
      mapped_articles << { article: article, read: read, number_of_articles: number_of_articles }
    end
    render json: mapped_articles, status: :ok
  rescue StandardError => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  def read
    filtered_params = read_params
    article_user = ArticlesUser.where(article_id: filtered_params[:article_id], user: current_user).first
    if article_user.update(:read => filtered_params[:read])
      render json: { article: article_user.article, read: article_user[:read] }, status: :ok
    else
      render json: { errors: article_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def read_params
    params.permit(:article_id, :read)
  end

  def article_params
    required_params = params.require(:article).permit(:feed_id)
    raise CustomExceptions::BadParams.new("no feed id") if required_params.empty?
    required_params
  end
end
