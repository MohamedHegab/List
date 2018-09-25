module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  NotAuthinticated = Class.new(StandardError)
  
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message , status: :not_found }
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.message , status: :unprocessable_entity }
    end

    rescue_from ApplicationController::NotAuthinticated do |e|
      render json: { errors: "Not Authenticated", status: :fail}
    end

    rescue_from CanCan::AccessDenied do |exception|
      render json: {message: 'Don\'t have authorization', status: :fail, code: 8000} 
    end
  end
end