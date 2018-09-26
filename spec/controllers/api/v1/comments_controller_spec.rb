require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
	describe "GET #index" do 
    context "comments for cards" do 
      context "admin can access all comments" do
        login_admin
        before(:each) do
          @card = FactoryBot.create(:card)
          3.times { FactoryBot.create(:comment_for_card, commentable: @card, user: User.first) }
          FactoryBot.create(:comment_for_card, commentable: @card)
          get :index, params: {card_id: @card.id}
        end

        it "cards all the comments" do
          comment_response = json_response
          expect(comment_response[:data].length).to eql 4
        end
      end

      context "member can access all comments for the card he is member" do
        login_member
        
        before(:each) do
          @card = FactoryBot.create(:card)
          @card.list.assign_member(User.first.id)
          3.times { FactoryBot.create(:comment_for_card, user: User.first, commentable: @card) }
          FactoryBot.create(:comment_for_card, commentable: @card)
          get :index, params: {card_id: @card.id}
        end

        it "" do
          comment_response = json_response
          expect(comment_response[:data].length).to eql 4
        end
      end
    end

    context "comments for comments" do 
      context "admin can access all comments" do
        login_admin
        before(:each) do
          @card = FactoryBot.create(:card)
        	@comment = FactoryBot.create(:comment_for_card, commentable: @card)
          3.times { FactoryBot.create(:comment_for_comment, commentable: @comment) }
          get :index, params: {comment_id: @comment.id}
        end

        it "comments all the comments" do
          comment_response = json_response
          expect(comment_response[:data].length).to eql 3
        end
      end

      context "member can access all comments for the card he is member" do
        login_member
        
        before(:each) do
          @card = FactoryBot.create(:card)
          @card.list.assign_member(User.first.id)
          @comment = FactoryBot.create(:comment_for_card, commentable: @card)
          3.times { FactoryBot.create(:comment_for_comment, commentable: @comment) }
          get :index, params: {comment_id: @comment.id}
        end

        it "" do
          comment_response = json_response
          expect(comment_response[:data].length).to eql 3
        end
      end
    end
  end

  describe "GET #show" do
  	context "admin" do
			login_admin
	    before(:each) do
	      @comment = FactoryBot.create :comment_for_card
	      get :show, params: { card_id: @comment.commentable.id, id: @comment.id }
	    end

	    it "returns the information about the comment on a hash" do
	      comment_response = json_response
	      expect(comment_response[:data][:attributes][:content]).to eql @comment.content
	    end

	    it { should respond_with 200 }
	  end
	  context "member" do
			login_member
	    before(:each) do
	      @comment = FactoryBot.create :comment_for_card
	      @comment.commentable.list.assign_member(User.first)
	      get :show, params: { card_id: @comment.commentable.id, id: @comment.id }
	    end

	    it "returns the information about the comment on a hash" do
	      comment_response = json_response
	      expect(comment_response[:data][:attributes][:content]).to eql @comment.content
	    end

	    it { should respond_with 200 }
	  end
  end

  describe "POST #create" do

    context "when is successfully created" do
      login_admin
      before(:each) do
      	@card = FactoryBot.create(:card, owner: User.first)
        @comment_attributes = FactoryBot.attributes_for :comment_for_card
        post :create, params: { card_id: @card.id, comment: @comment_attributes }
      end

      it "renders the json representation for the user record just created" do
        comment_response = json_response
        expect(comment_response[:data][:attributes][:content]).to eql @comment_attributes[:content]
      end

      it { should respond_with 201 }
    end

    context "when is not created not valid attributes" do
      login_admin
      before(:each) do
      	@card = FactoryBot.create(:card, owner: User.first)
        @invalid_comment_attributes = { content: nil }
        post :create, params: { card_id: @card.id, comment: @invalid_comment_attributes }
      end

      it "renders an errors json" do
        comment_response = json_response
        expect(comment_response).to have_key(:errors)
      end

      it "renders the json errors on why the comment could not be created" do
        comment_response = json_response
        expect(comment_response[:errors][:content]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when member is assigned to the card" do
      login_member
      before(:each) do
      	@card = FactoryBot.create(:card)
      	@card.list.assign_member(User.first)
        @comment_attributes = FactoryBot.attributes_for :comment_for_card, commentable_type: 'Card', commentable_id: @card.id
        post :create, params: { card_id: @card.id, comment: @comment_attributes }
      end

      it "renders the data" do
        comment_response = json_response
        expect(comment_response[:data][:attributes][:content]).to eql @comment_attributes[:content]
      end

      it { should respond_with 201 }
    end

    context "when member is not assigned to the card" do
      login_member
      before(:each) do
      	@card = FactoryBot.create(:card)
        @comment_attributes = FactoryBot.attributes_for :comment_for_card
        post :create, params: { card_id: @card.id, comment: @comment_attributes }
      end

      it "gives not authorized" do
        comment_response = json_response
        expect(comment_response[:message]).to include "Don't have authorization"
      end

      it { should respond_with 200 }
    end
  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      login_admin
      before(:each) do
        @comment = FactoryBot.create :comment_for_card, user: User.first
        @content = 'female'
        patch :update, params: { card_id: @comment.commentable.id, id: @comment.id,
                         comment: FactoryBot.attributes_for(:comment, content: 'female') }
      end

      it "renders the json representation for the updated user" do
        comment_response = json_response
        expect(comment_response[:data][:attributes][:content]).to eql @content
      end

      it { should respond_with 200 }
    end

    context "when is not created not valid content" do
      login_admin
      before(:each) do
        @comment = FactoryBot.create :comment_for_card, user: User.first
        patch :update, params: { card_id: @comment.commentable.id, id: @comment.id,
                         comment: { content: nil } }
      end

      it "renders an errors json" do
        comment_response = json_response
        expect(comment_response).to have_key(:errors)
      end

      it "renders the json errors on why the comment could not be created" do
        comment_response = json_response
        expect(comment_response[:errors][:content]).to include "can't be blank"
      end

      it { should respond_with 200 }
    end

    context "when is created member in the card" do
      login_member
      before(:each) do
      	@card = FactoryBot.create(:card)
        @card.list.assign_member(User.first)
        @comment = FactoryBot.create :comment_for_card, commentable: @card, user: User.first
        patch :update, params: { card_id: @comment.commentable.id, id: @comment.id,
                         comment: { content: 'good' } }
      end

      it "renders the json representation for the updated user" do
        comment_response = json_response
        expect(comment_response[:data][:attributes][:content]).to eql 'good'
      end

      it { should respond_with 200 }
    end
  end

  describe "DELETE #destroy" do
    context "can destroy comment when admin" do 
      login_admin
      before(:each) do
        @comment = FactoryBot.create :comment_for_card, user: User.first
      end
      it "" do
        expect {
          delete :destroy, params: {card_id: @comment.commentable.id, id: @comment.id}
        }.to change(Comment, :count).by(-1)
      end
    end
    context "can destroy the comment when member" do 
      login_member
      before(:each) do
      	@card = FactoryBot.create :card
      	@card.list.assign_member(User.first)
        @comment = FactoryBot.create :comment_for_card, commentable: @card, user: User.first
      end
      it "" do 
        expect {
          delete :destroy, params: {card_id: @card.id, id: @comment.id}
        }.to change(Comment, :count).by(-1)
      end
    end
  end
end
