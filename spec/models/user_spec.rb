require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  subject { @user }
  it { should respond_to(:user_name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }

  describe "when user name is not present" do
    before { @user.user_name = " " }
    it { should validate_presence_of(:user_name) }
    it { should validate_uniqueness_of(:user_name) }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('my_user_name').for(:user_name) }
  end
end