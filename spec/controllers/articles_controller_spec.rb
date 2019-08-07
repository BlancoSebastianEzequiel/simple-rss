require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
    @feed = FactoryBot.create :feed
    @feed.users << @user
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

      it "add more articles but does not repeat" do
        @article_attributes = { feed_id: @feed.id }
        patch :update, params: { article: @article_attributes }, format: :json
        article_response = json_response
        dup = article_response.detect{ |article| article_response.count(article[:link]) > 1 }
        expect(dup).to eql nil
      end

      it "another user has the same or more articles if the user updated later" do
        get :show, params: { feed_id: @feed.id }, format: :json
        first_user_article_response = JSON.parse(response.body)
        @another_user = FactoryBot.create :user
        @feed.users << @another_user
        api_authorization_header(@another_user.auth_token)
        get :show, params: { feed_id: @feed.id }, format: :json
        second_user_article_response = JSON.parse(response.body)
        expect(second_user_article_response.length).to eql 0
        expect(first_user_article_response.length > second_user_article_response.length).to eql true
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

    it "returns the list of articles" do
      article_response = json_response
      expect(article_response.is_a? Array).to eql true
    end

    it { should respond_with :ok }
  end

  describe "PATCH #read" do
    before(:each) do
      @article = FactoryBot.create(:article, feed_id: @feed.id)
      @article.users << @user
      patch :read, params: { article_id: @article.id, read: true }, format: :json
    end

    it "reads an article" do
      get :show, params: { feed_id: @feed.id }, format: :json
      article_response = json_response
      expect(article_response.length).to eql 1
      expect(article_response[0][:read]).to eql true
    end

    it { should respond_with :ok }
  end
end
