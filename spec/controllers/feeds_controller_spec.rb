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
      delete :destroy, params: { id: @feed.id }, format: :json
    end

    it { should respond_with :no_content }

  end
end
