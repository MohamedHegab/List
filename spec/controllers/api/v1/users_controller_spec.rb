require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  describe "GET #index" do
    context "when is successfully list users" do
      login_admin
      before(:each) do
        @users = FactoryBot.create_list(:user, 3)
        get :index
      end
      
      it "lists users" do
        user_response = json_response
        expect(user_response[:data].count).to eql 4
      end

      it { should respond_with 200 }
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryBot.attributes_for(:admin).merge(role_input: 'admin')
        post :create, params: { user: @user_attributes }
      end

      it "renders the json representation for the user record just created" do
        user_response = json_response
        expect(user_response[:data][:attributes][:email]).to eql @user_attributes[:email]
      end

      it { should respond_with 201 }
    end

    context "when is not created" do
      before(:each) do
        #notice I'm not including the email
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, params: { user: @invalid_user_attributes }
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "can't be blank"
      end

      it { should respond_with 422 }
    end
  end
end