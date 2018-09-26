class Api::BaseController < ApplicationController
	include Authenticable

	# before_action :restrict_access_token

	def authenticate_with_token! 
  	raise ApplicationController::NotAuthinticated unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  private
  
  def set_page
    @page = params[:page] || 0
  end
end