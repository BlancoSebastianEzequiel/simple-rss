module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user = User.find_by(auth_token: request.headers['Authorization'])
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" }, status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end
end

module CustomExceptions
  class BadRss < StandardError
    attr_reader :status
    def initialize(msg="My default message")
      @status = :bad_request
      super(msg)
    end
  end

  class BadParams < StandardError
    attr_reader :status
    def initialize(msg="My default message")
      @status = :bad_request
      super(msg)
    end
  end
end