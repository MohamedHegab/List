class Api::V1::UsersController < Api::BaseController
	def index
    authenticate_with_token!
    users = User.all
    render json: users, status: 200, each_serializer: Users::IndexSerializer
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :role, :password, :password_confirmation)
  end
end
