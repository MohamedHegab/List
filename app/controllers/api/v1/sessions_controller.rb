class Api::V1::SessionsController < Api::BaseController
	def create
    @user = User.where(email: params[:user][:email]).first
    if @user&.valid_password?(params[:user][:password])
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render json: @user, status: 200, location: [:api, @user]
    else
      render json: { errors: "invalid email or password" }, status: 422
    end
  end

  def destroy
    authenticate_with_token!
    current_user.generate_authentication_token!
    current_user.save
    render json: { message: 'user signed out successfully'}, status: 204
  end
end
