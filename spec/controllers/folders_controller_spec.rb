require 'rails_helper'

RSpec.describe FoldersController, type: :controller do
  before(:each) do
    @user = FactoryBot.create :user
    api_authorization_header(@user.auth_token)
  end
  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @folder_attributes = FactoryBot.attributes_for :folder
        post :create, params: { folder: @folder_attributes }, format: :json
      end

      it "renders the json representation for the folder record just created" do
        feed_response = json_response
        expect(feed_response[:name]).to eql @folder_attributes[:name]
      end
    end
  end
end
