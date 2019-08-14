require 'rails_helper'

RSpec.describe Article, type: :model do
  before(:each) do
    @feed = FactoryBot.create(:feed)
    @article = FactoryBot.build(:article, feed_id: @feed.id)
  end
  subject { @article }
  it { should respond_to(:link) }
  it { should respond_to(:title) }
  it { should respond_to(:avatar) }
  it { should respond_to(:description) }
  it { should be_valid }
  it { should belong_to :feed }
  it { should have_many(:users).through(:articles_user) }

  describe "when url is not present" do
    before { @article.link = " " }
    it { should validate_presence_of(:link) }
    it { should validate_uniqueness_of(:link) }
    it { should_not be_valid }
  end
end
