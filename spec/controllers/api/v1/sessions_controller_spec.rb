require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
	before(:each) do
    @user = FactoryBot.create :admin, password: "MyPassword123", password_confirmation: "MyPassword123"
  end

  context "when the credentials are correct" do

    before(:each) do
      credentials = { email: @user.email, password: "MyPassword123"}
      post :create, params:{ user: credentials }
    end

    it "returns the user record corresponding to the given credentials" do
      @user.reload
      expect(json_response[:data][:attributes][:"auth-token"]).to eql @user.auth_token
    end

    it { should respond_with 200 }
  end

  context "when the credentials are incorrect" do

    before(:each) do
      credentials = { email: @user.email, password: "invalidpassword" }
      post :create, params: { user: credentials }
    end

    it "returns a json with an error" do
      expect(json_response[:errors]).to eql "invalid email or password"
    end

    it { should respond_with 422 }
  end


end
