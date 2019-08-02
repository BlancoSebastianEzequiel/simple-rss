class SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_name = params[:session][:user_name]
    user = user_name.present? && User.find_by(user_name: user_name)

    if user && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: :ok
    else
      render json: { errors: "Invalid user name or password" }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    return render json: { errors: "Invalid id" }, status: :unauthorized unless user
    user.generate_authentication_token!
    user.save
    head :no_content
  end
end
