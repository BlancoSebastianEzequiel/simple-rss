class SessionsController < ApplicationController

  def create
    user_password = params[:session][:password]
    user_name = params[:session][:user_name]
    user = user_name.present? && User.find_by(user_name: user_name)

    if user && user.valid_password?(user_password)
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200 #, location: [:api, user]
    else
      render json: { errors: "Invalid user name or password" }, status: 422
    end
  end
end
