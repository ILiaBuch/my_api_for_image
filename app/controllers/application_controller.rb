class ApplicationController < ActionController::API
  include ActionController::RespondWith
  include ActionController::Helpers
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from 'Mongoid::Errors::DocumentNotFound' do |exception|
    specify_json_error(:record_not_found, :bad_request, details: exception.message)
  end

  rescue_from 'Mongoid::Errors::Validations' do |exception|
    specify_json_error(:image_name_should_be_valid, :unprocessable_entity, details: exception.message)
  end

  rescue_from 'ActionController::ParameterMissing' do |exception|
    specify_json_error(:request_has_incorrect_format, :unprocessable_entity, details: exception.message)
  end

  rescue_from 'Errno::ENOENT' do |exception|
    specify_json_error(:some_folder_is_absent, :internal_server_error, details: exception.message)
  end

  rescue_from 'ActionController::RoutingError' do |exception|
    specify_json_error(:you_are_using_incorrect_url, :not_found, details: exception.message)
  end

  def raise_not_found
    raise ActionController::RoutingError.new("No route matches #{params[:unmatched_route]}")
  end

  private

  def current_user
    authenticate_with_http_token do |token, options|
     User.where(access_key: token ).first
    end
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
     authenticate_key || render_unauthorized
   end

   def authenticate_key
    authenticate_with_http_token do |token, options|
      User.find_by(access_key: token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    render json: { errors: [message:  "You don not have  acces_key, for get acces_key have to make POST request on /users.json" , status: 401 ] }, status: :unauthorized
  end

end
