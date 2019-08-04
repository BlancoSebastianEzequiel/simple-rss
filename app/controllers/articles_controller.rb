require 'rss'
require 'open-uri'

class ArticlesController < ApplicationController

  respond_to :json
  wrap_parameters :feed, include: %i[feed_id]

  def show
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    articles = Feed.find_by(id: params[:feed_id]).articles
    if articles
      respond_with articles
    else
      render json: { errors: articles.errors }, status: :unprocessable_entity
    end
  rescue Exception => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  private

  def article_params
    params.require(:article).permit(:feed_id)
  end
end
