class UsersController < ApplicationController
  respond_to :json
  wrap_parameters :user, include: %i[user_name password password_confirmation]

  def show
    respond_with User.find(params[:id])
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    head :no_content
  end


  private

  def user_params
    params.require(:user).permit(:user_name, :password, :password_confirmation)
  end
end
