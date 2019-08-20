class FeedsController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:show, :create, :destroy]

  def show
    feeds = current_user.feeds
    if feeds
      respond_with feeds
    else
      render json: { errors: feeds.errors }, status: :unprocessable_entity
    end
  end

  def create
    res = FeedFactory.create(current_user, params[:feed][:url])
    render json: res[:json], status: res[:status]
  end

  def destroy
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

    feed.folders.each do |folder|
      FolderFeedUser.find_by(folder: folder, feed: feed, user_id: current_user.id).delete
      if FolderFeedUser.where(folder: folder).empty?
        folder.delete
      end
    end

    if feed.users.length == 0
      feed.delete
      render json: { feed:  feed, articles_deleted: articles_deleted }, status: :no_content
    else
      render json: { feed:  feed, articles_deleted: articles_deleted }, status: :ok
    end
  end
end
