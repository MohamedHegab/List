class Api::V1::ListsController < Api::BaseController
  before_action :authenticate_with_token!
  before_action :set_list, only: [:show, :update, :destroy, :assign_member, :unassign_member]
	load_and_authorize_resource
	
	def index
		lists = List.accessible_by(current_ability).paginate(:page => params[:page], per_page: 10)
    render json: lists, status: 200
	end

	def show
		render json: @list, include: ('cards'), status: 200
	end

	def update
		if @list.update(list_params)
			render json: @list, status: 200
    else
			render json: {errors: @list.errors, status: 422}
    end
	end

	def create
	  @list = List.new(list_params)
	  @list.owner = current_user

    if @list.valid? && @list.save
			render json: @list, status: 201
    else
			render json: {errors: @list.errors, status: 422}
    end
	end

	def destroy
    if @list.destroy
			render json: { message: 'List destroyed'}, status: 200
    else
			render json: { message: 'List not destroyed'}, status: 422
    end
	end

	def assign_member
		user_id = params[:list][:member_id]
		check_assign = @list.assign_member(user_id)
		if check_assign[:status]
			render json: @list, status: 200
		else
			render json: { message: check_assign[:message]}, status: 200
		end
	end
	
	def unassign_member
		user_id = params[:list][:member_id]
		if @list.unassign_member(user_id)
			render json: @list, status: 200
		else
			render json: { message: 'Cannot unassign this member'}, status: 200
		end
	end

	private

	def set_list
    @list = List.find(params[:id])
	end

	def list_params
	  params.require(:list).permit(:title)
	end
end
