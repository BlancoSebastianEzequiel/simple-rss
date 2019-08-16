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
        post :create, params: { folder: { name: @name, feeds_id: [ @feed.id ] } }, format: :json
      end

      it "renders the json representation for the folder record just created" do
        folder_response = json_response
        expect(folder_response[:folder][:name]).to eql @name
        expect(folder_response[:feeds_id][0]).to eql @feed.id
      end
    end

    context "when name is missing" do
      before(:each) do
        post :create, params: { folder: { feeds_id: [ @feed.id ] } }, format: :json
      end

      it "renders an errors json" do
        folder_response = json_response
        expect(folder_response).to have_key(:errors)
      end
    end
  end

  describe "GET #show" do
    before(:each) do
      @name = FactoryBot.attributes_for(:folder)[:name]
      post :create, params: { folder: { name: @name, feeds_id: [ @feed.id ] } }, format: :json
      get :show, params: { feed_id: @feed.id }, format: :json
    end
    context "when we get the folder after storing feeds on them" do
      it "returns the list of folders" do
        feed_response = json_response
        expect(feed_response.length).to eql 1
      end

      it { should respond_with :ok }
    end
  end
end
