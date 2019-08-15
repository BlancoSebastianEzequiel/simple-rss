class FoldersController < ApplicationController
  respond_to :json
  wrap_parameters :feed, include: %i[url]
  before_action :authenticate_with_token!, :only => [:create]

  def create
    render json: { name: "" }, status: :created
  end
end
