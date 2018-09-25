require 'rails_helper'

RSpec.describe Api::V1::ListsController, type: :controller do
	describe "GET #show" do
		login_admin
    before(:each) do
      @list = FactoryBot.create :list
      get :show, params: { id: @list.id }
    end

    it "returns the information about the list on a hash" do
      list_response = json_response
      expect(list_response[:data][:attributes][:title]).to eql @list.title
    end

    it { should respond_with 200 }
  end

  describe "POST #create" do

    context "when is successfully created" do
      login_admin
      before(:each) do
        @list_attributes = FactoryBot.attributes_for :list
        post :create, params: { list: @list_attributes }
      end

      it "renders the json representation for the user record just created" do
        list_response = json_response
        expect(list_response[:data][:attributes][:title]).to eql @list_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created not valid attributes" do
      login_admin
      before(:each) do
        @invalid_list_attributes = { title: nil }
        post :create, params: { list: @invalid_list_attributes }
      end

      it "renders an errors json" do
        list_response = json_response
        expect(list_response).to have_key(:errors)
      end

      it "renders the json errors on why the list could not be created" do
        list_response = json_response
        expect(list_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when is not created has no authorization" do
      login_member
      before(:each) do
        @list_attributes = FactoryBot.attributes_for :list
        post :create, params: { list: @list_attributes }
      end

      it "renders a not authorized message" do
        list_response = json_response
        expect(list_response[:message]).to include("Don't have authorization")
      end

      it { should respond_with 200 }
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      login_admin
      before(:each) do
        @list = FactoryBot.create :list, owner: User.first
        @title = 'female'
        patch :update, params: { id: @list.id,
                         list: FactoryBot.attributes_for(:list, title: 'female') }
      end

      it "renders the json representation for the updated user" do
        list_response = json_response
        expect(list_response[:data][:attributes][:title]).to eql @title
      end

      it { should respond_with 200 }
    end

    context "when is not created not valid title" do
      login_admin
      before(:each) do
        @list = FactoryBot.create :list, owner: User.first
        patch :update, params: { id: @list.id,
                         list: { title: nil } }
      end

      it "renders an errors json" do
        list_response = json_response
        expect(list_response).to have_key(:errors)
      end

      it "renders the json errors on why the list could not be created" do
        list_response = json_response
        expect(list_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when is not created has no authorization" do
      login_member
      before(:each) do
        @list = FactoryBot.create :list
        patch :update, params: { id: @list.id,
                         list: { title: 'good' } }
      end

      it "renders a not authorized message" do
        list_response = json_response
        expect(list_response[:message]).to include("Don't have authorization")
      end

      it { should respond_with 200 }
    end
  end

  describe "DELETE #destroy" do
    context "can destroy list when admin" do 
      login_admin
      before(:each) do
        @list = FactoryBot.create :list, owner: User.first
      end
      it "" do
        expect {
          delete :destroy, params: {id: @list.id}
        }.to change(List, :count).by(-1)
      end
    end
    context "can't destroy the list when sales" do 
      login_member
      before(:each) do 
        @list = FactoryBot.create :list
        delete :destroy, params: {id: @list.id}
      end
      it "" do 
        list_response = json_response
        expect(list_response[:message]).to include("Don't have authorization")
      end
    end
  end

  describe "#Post assign_member" do 
  	context "can assign member when is not assigned" do 
  		login_admin
      before(:each) do 
        @list = FactoryBot.create :list, owner: User.first
        @user = FactoryBot.create :user
        post :assign_member, params: {id: @list.id, list: { member_id: @user.id}}
      end

      it "successfully assign user" do
        list_response = json_response
        expect(list_response[:data][:attributes][:title]).to eql @list.title
      end

      it {should respond_with 200}
  	end

  	context "can not assign member when is already assigned" do 
  		login_admin
      before(:each) do 
        @list = FactoryBot.create :list, owner: User.first
        @user = FactoryBot.create :user
        @list.assign_member(@user.id)
        post :assign_member, params: {id: @list.id, list: { member_id: @user.id}}
      end

      it "successfully assign user" do
        list_response = json_response
        expect(list_response[:message]).to include("This member already in the list")
      end

      it {should respond_with 200}
  	end

  	context "can not assign member when is owner" do 
  		login_admin
      before(:each) do 
        @list = FactoryBot.create :list, owner: User.first
        post :assign_member, params: {id: @list.id, list: { member_id: @list.owner.id}}
      end

      it "successfully assign user" do
        list_response = json_response
        expect(list_response[:message]).to include("The owner cannot be assigned as member")
      end

      it {should respond_with 200}
  	end
  end


end
