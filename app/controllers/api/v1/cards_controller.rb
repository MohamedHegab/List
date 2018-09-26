class Api::V1::CardsController < Api::BaseController
	before_action :authenticate_with_token!
  before_action :set_list, except: [:show]
  before_action :set_card, only: [:show, :update, :destroy]
	load_and_authorize_resource except: [:create]
	
	def index
		cards = @list.cards.accessible_by(current_ability).by_comments
    paginate json: cards, status: 200
	end

	def show
		render json: @card, include: 'comments', status: 200
	end

	def update
		@card.list = @list
		if @card.update(card_params)
			render json: @card, status: 200
    else
			render json: {errors: @card.errors, status: 422}
    end
	end

	def create
	  @card = Card.new(card_params)
		@card.list = @list
	  @card.owner = current_user

	  authorize! :create, @card

    if @card.valid? && @card.save
			render json: @card, status: 201
    else
			render json: {errors: @card.errors, status: 422}
    end
	end

	def destroy
    if @card.destroy
			render json: { message: 'Card destroyed'}, status: 200
    else
			render json: { message: 'Card not destroyed'}, status: 422
    end
	end

	private

	def set_list
		@list = List.find(params[:list_id])
	end

	def set_card
    @card = Card.find(params[:id])
	end

	def card_params
	  params.require(:card).permit(:title, :description)
	end
end
