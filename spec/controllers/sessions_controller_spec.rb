require 'rails_helper'
require 'spec_helper'

RSpec.describe SessionsController, type: :controller do
  describe "POST #create" do
    before(:each) do
      @user = FactoryBot.create :user
    end

    context "when the credentials are correct" do

      before(:each) do
        credentials = { user_name: @user.user_name, password: "12345678" }
        post :create, params: { session: credentials }
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(json_response[:auth_token]).to eql @user.auth_token
      end

      it { should respond_with 200 }
    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { user_name: @user.user_name, password: "invalidpassword" }
        post :create, params: { session: credentials }
      end

      it "returns a json with an error" do
        expect(json_response[:errors]).to eql "Invalid user name or password"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do

    before(:each) do
      @user = FactoryBot.create :user
      sign_in @user
      delete :destroy, params: { id: @user.auth_token }
    end

    it { should respond_with 204 }
  end
end
