require 'rails_helper'

RSpec.describe Api::V1::CardsController, type: :controller do
	describe "GET #index" do 
    context "admin can access all cards" do
      login_admin
      before(:each) do
      	@list = FactoryBot.create(:list)
        3.times { FactoryBot.create(:card, owner: User.first, list: @list) }
        FactoryBot.create(:card, list: @list)
        get :index, params: {list_id: @list.id}
      end

      it "lists all the cards" do
        card_response = json_response
        expect(card_response[:data].length).to eql 4
      end
    end

    context "member can access all cards for the list he is member" do
      login_member
      
      before(:each) do
        @list = FactoryBot.create(:list)
        @list.assign_member(User.first.id)
        3.times { FactoryBot.create(:card, owner: User.first, list: @list) }
        FactoryBot.create(:card, list: @list)
        get :index, params: {list_id: @list.id}
      end

      it "" do
        card_response = json_response
        expect(card_response[:data].length).to eql 4
      end
    end
  end

  describe "GET #show" do
  	context "admin" do
			login_admin
	    before(:each) do
	      @card = FactoryBot.create :card
	      get :show, params: { list_id: @card.list.id, id: @card.id }
	    end

	    it "returns the information about the card on a hash" do
	      card_response = json_response
	      expect(card_response[:data][:attributes][:title]).to eql @card.title
	    end

	    it { should respond_with 200 }
	  end
	  context "member" do
			login_member
	    before(:each) do
	      @card = FactoryBot.create :card
	      @card.list.assign_member(User.first)
	      get :show, params: { list_id: @card.list.id, id: @card.id }
	    end

	    it "returns the information about the card on a hash" do
	      card_response = json_response
	      expect(card_response[:data][:attributes][:title]).to eql @card.title
	    end

	    it { should respond_with 200 }
	  end
  end

  describe "POST #create" do

    context "when is successfully created" do
      login_admin
      before(:each) do
      	@list = FactoryBot.create(:list, owner: User.first)
        @card_attributes = FactoryBot.attributes_for :card
        post :create, params: { list_id: @list.id, card: @card_attributes }
      end

      it "renders the json representation for the user record just created" do
        card_response = json_response
        expect(card_response[:data][:attributes][:title]).to eql @card_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when is not created not valid attributes" do
      login_admin
      before(:each) do
      	@list = FactoryBot.create(:list, owner: User.first)
        @invalid_card_attributes = { title: nil }
        post :create, params: { list_id: @list.id, card: @invalid_card_attributes }
      end

      it "renders an errors json" do
        card_response = json_response
        expect(card_response).to have_key(:errors)
      end

      it "renders the json errors on why the card could not be created" do
        card_response = json_response
        expect(card_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when member is assigned to the list" do
      login_member
      before(:each) do
      	@list = FactoryBot.create(:list)
      	@list.assign_member(User.first)
        @card_attributes = FactoryBot.attributes_for :card
        post :create, params: { list_id: @list.id, card: @card_attributes }
      end

      it "renders the data" do
        card_response = json_response
        expect(card_response[:data][:attributes][:title]).to eql @card_attributes[:title]
      end

      it { should respond_with 201 }
    end

    context "when member is not assigned to the list" do
      login_member
      before(:each) do
      	@list = FactoryBot.create(:list)
        @card_attributes = FactoryBot.attributes_for :card
        post :create, params: { list_id: @list.id, card: @card_attributes }
      end

      it "gives not authorized" do
        card_response = json_response
        expect(card_response[:message]).to include "Don't have authorization"
      end

      it { should respond_with 200 }
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      login_admin
      before(:each) do
        @card = FactoryBot.create :card, owner: User.first
        @title = 'female'
        patch :update, params: { list_id: @card.list.id, id: @card.id,
                         card: FactoryBot.attributes_for(:card, title: 'female') }
      end

      it "renders the json representation for the updated user" do
        card_response = json_response
        expect(card_response[:data][:attributes][:title]).to eql @title
      end

      it { should respond_with 200 }
    end

    context "when is not created not valid title" do
      login_admin
      before(:each) do
        @card = FactoryBot.create :card, owner: User.first
        patch :update, params: { list_id: @card.list.id, id: @card.id,
                         card: { title: nil } }
      end

      it "renders an errors json" do
        card_response = json_response
        expect(card_response).to have_key(:errors)
      end

      it "renders the json errors on why the card could not be created" do
        card_response = json_response
        expect(card_response[:errors][:title]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when is created member in the list" do
      login_member
      before(:each) do
      	@list = FactoryBot.create(:list)
        @list.assign_member(User.first)
        @card = FactoryBot.create :card, list: @list, owner: User.first
        patch :update, params: { list_id: @card.list.id, id: @card.id,
                         card: { title: 'good' } }
      end

      it "renders the json representation for the updated user" do
        card_response = json_response
        expect(card_response[:data][:attributes][:title]).to eql 'good'
      end

      it { should respond_with 200 }
    end
  end

  describe "DELETE #destroy" do
    context "can destroy card when admin" do 
      login_admin
      before(:each) do
        @card = FactoryBot.create :card, owner: User.first
      end
      it "" do
        expect {
          delete :destroy, params: {list_id: @card.list.id, id: @card.id}
        }.to change(Card, :count).by(-1)
      end
    end
    context "can destroy the card when member" do 
      login_member
      before(:each) do
      	@list = FactoryBot.create :list
      	@list.assign_member(User.first)
        @card = FactoryBot.create :card, list: @list, owner: User.first
      end
      it "" do 
        expect {
          delete :destroy, params: {list_id: @list.id, id: @card.id}
        }.to change(Card, :count).by(-1)
      end
    end
  end
end
