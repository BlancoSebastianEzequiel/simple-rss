class FoldersController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:create]

  def create
    feeds = Feed.where(id: params[:folder][:feeds_id])
    folder = Folder.find_by(name: params[:folder][:name]) || Folder.new(folder_params)
    folder_feed_user_ids = []
    feeds.each do |feed|
      if FolderFeedUserId.where(folder: folder, feed: feed, user_id: current_user.id).nil?
        folder_feed_user_ids << FolderFeedUserId.create(folder: folder, feed: feed, user_id: current_user.id)
      end
    end
    if folder.save
      feeds_id = feeds.map {|feed| feed.id}
      render json: { folder: folder, feeds_id: feeds_id }, status: :created
    else
      folder_feed_user_ids_id = folder_feed_user_ids.map {|folder_feed_user_id| folder_feed_user_id.id}
      FolderFeedUserId.where(id: folder_feed_user_ids_id).delete_all
      render json: { errors: folder.errors }, status: :unprocessable_entity
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :feeds_id)
  end
end
