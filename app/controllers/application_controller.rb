class ApplicationController < ActionController::API
  include ActionController::RespondWith
  include ActionController::Helpers
  rescue_from 'Mongoid::Errors::DocumentNotFound' do |exception|
    specify_json_error(:record_not_found, :bad_request, details: exception.message)
  end

  rescue_from 'Mongoid::Errors::Validations' do |exception|
    specify_json_error(:image_name_should_be_unique, :unprocessable_entity, details: exception.message)
  end



  private

  def current_user
     User.where(access_key: params[:access_key]).first
  end
  
  def specify_json_error(code, status, options = {})
    status = Rack::Utils::SYMBOL_TO_STATUS_CODE[status] if status.is_a? Symbol
    error = {
      code: I18n.t("error_codes.#{code}.code"),
      title: I18n.t("error_codes.#{code}.message"),
      status: status
    }.merge(options)
    render json: { errors: [error] }, status: status
   end

   protected
   def authenticate
     user = User.where(access_key: params[:access_key]).first
     render json: {status: :unathorized} and return false unless user
   end

end
