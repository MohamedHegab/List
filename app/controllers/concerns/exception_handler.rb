module ExceptionHandler
  # provides the more graceful `included` method
  extend ActiveSupport::Concern

  NotAuthorized = Class.new(StandardError)
  
  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: { message: e.message , status: :not_found }
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: { message: e.message , status: :unprocessable_entity }
    end

    rescue_from ApplicationController::NotAuthorized do |e|
      render json: { errors: "Not Authorized", status: :fail}
    end
  end
end