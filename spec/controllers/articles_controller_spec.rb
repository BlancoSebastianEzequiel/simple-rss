require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
    @feed = FactoryBot.create :feed
  end
  describe "GET #show" do
    before(:each) do
      get :show, params: { feed_id: @feed.id }, format: :json
    end

    it "returns the list of users feeds" do
      article_response = json_response
      expect(article_response.is_a? Array).to eql true
      # expect(article_response[0][:link]).to eql @feed_attributes[:url]
    end

    it { should respond_with :ok }
  end
end
