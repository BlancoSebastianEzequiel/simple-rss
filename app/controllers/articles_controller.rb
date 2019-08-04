require 'rss'
require 'open-uri'

class ArticlesController < ApplicationController

  respond_to :json
  wrap_parameters :feed, include: %i[feed_id]

  def show
    return render json: { errors: "no token" }, status: :unauthorized unless current_user
    feed = Feed.find_by(id: params[:feed_id])
    if feed.user.all? { |a_user| a_user.id != current_user.id }
      return render json: { errors: "you are not subscribed to this feed" }, status: :unprocessable_entity
    end
    respond_with feed.articles
  rescue Exception => ex
    render json: { errors: ex.message }, status: :internal_server_error
  end

  private

  def article_params
    params.require(:article).permit(:feed_id)
  end
end
