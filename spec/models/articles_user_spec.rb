require 'rails_helper'

RSpec.describe ArticlesUser, type: :model do
  before(:each) do
    @feed = FactoryBot.create(:feed)
    @article = FactoryBot.create(:article, feed_id: @feed.id)
    @user = FactoryBot.create(:user)
    @articles_users = FactoryBot.build(:articles_user, user: @user, article: @article)
  end
  subject { @articles_users }
  it { should respond_to(:user) }
  it { should respond_to(:article) }
  it { should respond_to(:read) }
  it { should be_valid }
  it { should belong_to :user }
  it { should belong_to :article }

  describe "when url is not present" do
    before { @articles_users.user = nil }
    it { should belong_to :user }
    it { should_not be_valid }
  end
end
