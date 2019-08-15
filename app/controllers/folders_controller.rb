class FoldersController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:create]

  def create
    folder = Folder.new(folder_params)
    if folder.save
      render json: folder, status: :created
    else
      render json: { errors: folder.errors }, status: :unprocessable_entity
    end
  end

  private

  def folder_params
    params.require(:folder).permit(:name)
  end
end
