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
        feed_response = json_response
        expect(feed_response[:folder][:name]).to eql @name
        expect(feed_response[:feeds_id][0]).to eql @feed.id
      end
    end
  end
end
