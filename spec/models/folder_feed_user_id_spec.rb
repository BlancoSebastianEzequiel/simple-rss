require 'rails_helper'

RSpec.describe FolderFeedUserId, type: :model do
  before(:each) do
    @feed = FactoryBot.create(:feed)
    @user= FactoryBot.create(:user)
    @folder = FactoryBot.create(:folder)
    @folder_feed_user_id = FactoryBot.build(:folder_feed_user_id, folder: @folder, feed: @feed, user_id: @user.id)
  end
  subject { @folder_feed_user_id }

  it { should respond_to(:folder) }
  it { should respond_to(:feed) }
  it { should respond_to(:user_id) }
  it { should be_valid }
  it { should belong_to :folder }
  it { should belong_to :feed }

  describe "when folder is not present" do
    before { @folder_feed_user_id.folder = nil }
    it { should belong_to :folder }
    it { should_not be_valid }
  end

  describe "when feed is not present" do
    before { @folder_feed_user_id.feed = nil }
    it { should belong_to :feed }
    it { should_not be_valid }
  end

  describe "when user_id is not present" do
    before { @folder_feed_user_id.user_id = nil }
    it { should_not be_valid }
  end
end
