class User < ApplicationRecord
  has_and_belongs_to_many :feeds

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :user_name, presence: :true, uniqueness: { case_sensitive: true }, format: { without: /\s/ }
  validates :auth_token, uniqueness: true

  before_create :generate_authentication_token!
  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

  protected
  # From Devise module Validatable
  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end
end
