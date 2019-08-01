class UsersController < ApplicationController
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user
    # return render json: { errors: "no current user" }, status: 422 unless user
    if user.update(user_params)
      render json: user, status: 200#, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end


  private

  def user_params
    params.require(:user).permit(:user_name, :password, :password_confirmation)
  end
end
