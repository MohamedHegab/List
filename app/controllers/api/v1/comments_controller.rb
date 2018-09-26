class Api::V1::CommentsController < Api::BaseController
  before_action :authenticate_with_token!
  before_action :find_commentable
  before_action :set_comment, only: [:show]
	before_action :set_page, only: [:index]
	load_and_authorize_resource except: [:create]
	
	def index
		comments = @commentable.comments.accessible_by(current_ability).limit(1).offset(@page * 1)
    render json: comments, status: 200
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
	  @comment = @commentable.comments.new comment_params
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

	def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = Card.find_by_id(params[:card_id]) if params[:card_id]
  end

  def set_comment
  	@comment = Comment.find(params[:id])
  end

	def comment_params
	  params.require(:comment).permit(:content)
	end

end


