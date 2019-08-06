require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryBot.build(:user) }
  subject { @user }
  it { should respond_to(:user_name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should be_valid }
  it { should respond_to(:auth_token) }
  it { should validate_uniqueness_of(:auth_token) }
  it { should have_and_belong_to_many :feeds }
  it { should have_many(:articles).through(:articles_user) }

  describe "when user name is not present" do
    before { @user.user_name = " " }
    it { should validate_presence_of(:user_name) }
    it { should validate_uniqueness_of(:user_name) }
    it { should validate_confirmation_of(:password) }
    it { should allow_value('my_user_name').for(:user_name) }
  end

  describe "#generate_authentication_token!" do
    it "generates a unique token" do
      allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).to eql "auniquetoken123"
    end

    it "generates another token when one already has been taken" do
      existing_user = FactoryBot.create(:user, auth_token: "auniquetoken123")
      @user.generate_authentication_token!
      expect(@user.auth_token).not_to eql existing_user.auth_token
    end
  end
end