require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
  end
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @feed_attributes = FactoryBot.attributes_for :feed
        post :create, params: { feed: @feed_attributes }, format: :json
      end

      it "renders the json representation for the feed record just created" do
        feed_response = json_response
        expect(feed_response[:url]).to eql @feed_attributes[:url]
      end

      it "sub to many users" do
        feed_response = json_response
        expect(feed_response[:url]).to eql @feed_attributes[:url]
        @another_user = FactoryBot.create :user
        api_authorization_header(@another_user.auth_token)
        post :create, params: { feed: @feed_attributes }, format: :json
        feed_response = json_response
        expect(feed_response[:url]).to eql @feed_attributes[:url]
      end

      it { should respond_with :created }
    end

    context "when is not created" do
      before(:each) do
        @invalid_feed_attributes = { title: "title" }
        post :create, params: { feed: @invalid_feed_attributes }, format: :json
      end

      it "renders an errors json" do
        feed_response = json_response
        expect(feed_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        feed_response = json_response
        expect(feed_response[:errors][:url]).to include "can't be blank"
      end

      it { should respond_with :unprocessable_entity }
    end

    context "when is the url is not valid" do
      before(:each) do
        @invalid_feed_attributes = FactoryBot.attributes_for :feed
        @invalid_feed_attributes[:url] = "http://rss.cnn.com/rss/edi"
        post :create, params: { feed: @invalid_feed_attributes }, format: :json
      end

      it "renders an errors json" do
        feed_response = json_response
        expect(feed_response).to have_key(:errors)
      end

      it "renders an errors message" do
        feed_response = json_response
        expect(feed_response[:errors][:url]).to include "your url rss is not valid"
      end

      it { should respond_with :bad_request }
    end

  end
  describe "GET #show" do
    before(:each) do
      @feed_attributes = FactoryBot.attributes_for :feed
      post :create, params: { feed: @feed_attributes }, format: :json
      get :show, params: { user_id: @user.id }, format: :json
    end

    it "returns the list of users feeds" do
      feed_response = json_response
      expect(feed_response.length).to eql 1
      expect(feed_response[0][:url]).to eql @feed_attributes[:url]
    end

    it { should respond_with :ok }
  end

  describe "DELETE #destroy" do
    before(:each) do
      @feed = FactoryBot.create :feed
      @feed_attributes = FactoryBot.attributes_for :feed
      post :create, params: { feed: @feed_attributes }, format: :json
    end

    it "deletes all articles because the feed does not have any user" do
      delete :destroy, params: { id: @feed.id }, format: :json
      feed_response = json_response
      expect(feed_response[:articles_deleted].length > 0).to eql true
      should respond_with :no_content
    end

    it "deletes feed subscription to the current user" do
      @another_user = FactoryBot.create :user
      api_authorization_header(@another_user.auth_token)
      post :create, params: { feed: @feed_attributes }, format: :json
      @article = FactoryBot.create(:article, feed_id: @feed.id)
      @feed.articles << @article
      @another_user.articles << @article
      @user.articles << @article
      delete :destroy, params: { id: @feed.id }, format: :json
      feed_response = json_response
      expect(feed_response[:articles_deleted].length >= 0).to eql true
      should respond_with :ok
    end

    it "remove user-feed asociation" do
      @another_user = FactoryBot.create :user
      api_authorization_header(@another_user.auth_token)
      post :create, params: { feed: @feed_attributes }, format: :json
      delete :destroy, params: { id: @feed.id }, format: :json
      should respond_with :ok
    end

    it "remove user-feed asociation and the feed itself" do
      post :create, params: { feed: @feed_attributes }, format: :json
      delete :destroy, params: { id: @feed.id }, format: :json
      should respond_with :no_content
    end

    context "when two feeds are in the same folder" do
      before(:each) do
        @feed_1 = FactoryBot.create(:feed, url: "https://rss.nytimes.com/services/xml/rss/nyt/Americas.xml")
        @feed_2 = FactoryBot.create(:feed, url: "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml")
        @feed_1.users << @user
        @feed_2.users << @user
        @folder_1 = FactoryBot.create(:folder)
        @folder_2 = FactoryBot.create(:folder)
        @folder_feed_1_user_id = FactoryBot.create(:folder_feed_user_id, feed: @feed_1, folder: @folder_1, user_id: @user.id)
        @folder_feed_1_user_id = FactoryBot.create(:folder_feed_user_id, feed: @feed_1, folder: @folder_2, user_id: @user.id)
        @folder_feed_2_user_id = FactoryBot.create(:folder_feed_user_id, feed: @feed_2, folder: @folder_1, user_id: @user.id)
        @folder_feed_2_user_id = FactoryBot.create(:folder_feed_user_id, feed: @feed_2, folder: @folder_2, user_id: @user.id)
      end

      it "remove the feed and its articles, but not the folder" do
        delete :destroy, params: { id: @feed_1.id }, format: :json
        should respond_with :no_content
      end
    end
  end
end
