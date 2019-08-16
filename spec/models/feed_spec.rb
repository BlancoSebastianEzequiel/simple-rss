require 'rails_helper'

RSpec.describe Feed, type: :model do
  before { @feed = FactoryBot.build(:feed) }
  subject { @feed }
  it { should respond_to(:url) }
  it { should respond_to(:title) }
  it { should be_valid }
  it { should have_and_belong_to_many :users }
  it { should have_many(:folders).through(:folder_feed_user_id) }

  describe "when url is not present" do
    before { @feed.url = " " }
    it { should validate_presence_of(:url) }
    it { should validate_uniqueness_of(:url) }
    it { should_not be_valid }
  end
end
