require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
    @feed = FactoryBot.create :feed
  end

  describe "PUT/PATCH #update" do
    context "when is successfully created" do
      before(:each) do
        @article_attributes = { feed_id: @feed.id }
        patch :update, params: { article: @article_attributes }, format: :json
      end

      it "renders the json representation for the article record just created" do
        article_response = json_response
        expect(article_response.is_a? Array).to eql true
      end

      it { should respond_with :ok }
    end

    context "when is not created" do
      before(:each) do
        @invalid_article_attributes = { invalid: "invalid" }
        patch :update, params: { article: @invalid_article_attributes }, format: :json
      end

      it "renders an errors json" do
        article_response = json_response
        expect(article_response).to have_key(:errors)
      end

      it { should respond_with :bad_request }
    end
  end

  describe "GET #show" do
    before(:each) do
      FactoryBot.create(:article, feed_id: @feed.id)
      get :show, params: { feed_id: @feed.id }, format: :json
    end

    it "returns the list of users feeds" do
      article_response = json_response
      expect(article_response.is_a? Array).to eql true
    end

    it { should respond_with :ok }
  end
end
