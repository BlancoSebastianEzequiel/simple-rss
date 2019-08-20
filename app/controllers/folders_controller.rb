class FoldersController < ApplicationController
  respond_to :json
  wrap_parameters :folder, include: %i[name feed_ids]
  before_action :authenticate_with_token!, :only => [:create]

  def create
    feeds = Feed.where(id: params[:folder][:feed_ids])
    if feeds.empty?
      return render json: { errors: "no feeds id were given" }, status: :unprocessable_entity
    end
    folder = Folder.find_by(name: params[:folder][:name]) || Folder.new(folder_params)
    unless folder.save
      return render json: { errors: folder.errors }, status: :unprocessable_entity
    end
    feeds.each do |feed|
      next if folder.feeds.include? feed
      if FolderFeedUser.where(folder: folder, feed: feed, user_id: current_user.id).empty?
        folder_feed_user_id = FolderFeedUser.new(folder: folder, feed: feed, user_id: current_user.id)
        unless folder_feed_user_id.save
          folder.delete
          return render json: { errors: folder_feed_user_id.errors }, status: :unprocessable_entity
        end
      end
    end
    feed_ids = feeds.map {|feed| feed.id}
    render json: { folder: folder, feed_ids: feed_ids }, status: :created
  end

  def show
    feed = Feed.find_by(id: params[:feed_id])
    folder_feed_user_ids = if feed
       FolderFeedUser.where(feed: feed, user_id: current_user.id)
    else
      FolderFeedUser.where(user_id: current_user.id)
    end
    folders = folder_feed_user_ids.map {|folder_feed_user_id| folder_feed_user_id.folder}
    if folders
      respond_with folders
    else
      render json: { errors: folders.errors }, status: :unprocessable_entity
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :feed_ids)
  end
end
