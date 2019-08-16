class FoldersController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:create]

  def create
    feeds = Feed.where(id: params[:folder][:feeds_id])
    folder = Folder.find_by(name: params[:folder][:name]) || Folder.new(folder_params)
    unless folder.save
      return render json: { errors: folder.errors }, status: :unprocessable_entity
    end
    folder_feed_user_ids = []
    feeds.each do |feed|
      if FolderFeedUserId.where(folder: folder, feed: feed, user_id: current_user.id).empty?
        folder_feed_user_id = FolderFeedUserId.new(folder: folder, feed: feed, user_id: current_user.id)
        unless folder_feed_user_id.save
          folder.delete
          return render json: { errors: folder_feed_user_id.errors }, status: :unprocessable_entity
        end
        folder_feed_user_ids << folder_feed_user_id
      end
    end
    feeds_id = feeds.map {|feed| feed.id}
    render json: { folder: folder, feeds_id: feeds_id }, status: :created
  end

  def show
    feed = Feed.find_by(id: params[:feed_id])
    folder_feed_user_ids = if feed
       FolderFeedUserId.where(feed: feed, user_id: current_user.id)
    else
      FolderFeedUserId.where(user_id: current_user.id)
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
    params.require(:folder).permit(:name, :feeds_id)
  end
end
