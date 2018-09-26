class Api::V1::CommentsController < Api::BaseController
  before_action :authenticate_with_token!
  before_action :set_card, except: [:show]
  before_action :set_comment, only: [:show, :update, :destroy]
	load_and_authorize_resource except: [:create]
	
	def index
		comments = Comment.accessible_by(current_ability)
    paginate json: comments, status: 200
	end

	def show
		render json: @comment, include: ('comments'), status: 200
	end

	def update
		if @comment.update(comment_params)
			render json: @comment, status: 200
    else
			render json: {errors: @comment.errors, status: 422}
    end
	end

	def create
	  @comment = Comment.new(comment_params)
	  @comment.user = current_user

	  authorize! :create, @comment

    if @comment.valid? && @comment.save
			render json: @comment, status: 201
    else
			render json: {errors: @comment.errors, status: 422}
    end
	end

	def destroy
    if @comment.destroy
			render json: { message: 'Comment destroyed'}, status: 200
    else
			render json: { message: 'Comment not destroyed'}, status: 422
    end
	end

	private

	def set_card
		@card = Card.find(params[:card_id])
	end

	def set_comment
    @comment = Comment.find(params[:id])
	end

	def comment_params
	  params.require(:comment).permit(:content, :commentable_id, :commentable_type)
	end

end


