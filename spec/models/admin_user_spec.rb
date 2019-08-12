require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  before { @admin_user = FactoryBot.build(:admin_user) }
  subject { @admin_user }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }
end
