require 'rails_helper'

RSpec.describe FoldersController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
    @feed = FactoryBot.create(:feed)
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @name = FactoryBot.attributes_for(:folder)[:name]
        post :create, params: { folder: { name: @name, feed_ids: [ @feed.id ] } }, format: :json
      end

      it "renders the json representation for the folder record just created" do
        folder_response = json_response
        expect(folder_response[:folder][:name]).to eql @name
        expect(folder_response[:feed_ids][0]).to eql @feed.id
      end
    end

    context "when name is missing" do
      before(:each) do
        post :create, params: { folder: { feed_ids: [ @feed.id ] } }, format: :json
      end

      it "renders an errors json" do
        folder_response = json_response
        expect(folder_response).to have_key(:errors)
      end
    end

    context "when no feeds id are given" do
      before(:each) do
        @name = FactoryBot.attributes_for(:folder)[:name]
        post :create, params: { folder: { name: @name, feed_ids: [ ] } }, format: :json
      end

      it "renders an errors json" do
        folder_response = json_response
        expect(folder_response).to have_key(:errors)
      end
    end
  end

  describe "GET #show" do
    context "when we get the folder after storing feeds on them" do
      before(:each) do
        @name = FactoryBot.attributes_for(:folder)[:name]
        post :create, params: { folder: { name: @name, feed_ids: [ @feed.id ] } }, format: :json
        get :show, params: { feed_id: @feed.id }, format: :json
      end
      it "returns the list of folders" do
        feed_response = json_response
        expect(feed_response.length).to eql 1
      end

      it { should respond_with :ok }
    end

    context "when we get the folder without creating it" do
      before(:each) do
        get :show, params: { feed_id: @feed.id }, format: :json
      end
      it "returns an empty list of folders" do
        feed_response = json_response
        expect(feed_response.length).to eql 0
      end

      it { should respond_with :ok }
    end

    context "when two user get folders after one crating them and the other not" do
      before(:each) do
        @name = FactoryBot.attributes_for(:folder)[:name]
        post :create, params: { folder: { name: @name, feed_ids: [ @feed.id ] } }, format: :json
        get :show, params: { feed_id: @feed.id }, format: :json
      end
      it "returns an empty list of folders fo one user and a list not empty for the other" do
        feed_response = JSON.parse(response.body)
        expect(feed_response.length).to eql 1

        @another_user = FactoryBot.create :user
        api_authorization_header(@another_user.auth_token)
        get :show, params: { feed_id: @feed.id }, format: :json

        feed_response = JSON.parse(response.body)
        expect(feed_response.length).to eql 0
      end

      it { should respond_with :ok }
    end

    context "when we get the folders without specifying feeds id" do
      before(:each) do
        @name = FactoryBot.attributes_for(:folder)[:name]
        post :create, params: { folder: { name: @name, feed_ids: [ @feed.id ] } }, format: :json
        get :show, format: :json
      end

      it "returns all users folders" do
        feed_response = json_response
        expect(feed_response.length).to eql 1
      end
    end
  end
end
