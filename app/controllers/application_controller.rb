require "uri"

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  # rescue_from StandardError, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def render_404
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end

  def force_trailing_slash
    if params[:format] != nil
      return
    end
    url = URI.parse(request.original_url)
    url.path = url.path.chomp("/") + "/"
    if url.to_s != request.original_url
      redirect_to url.to_s
      return true
    else
      return false
    end
  end

  def basic_auth
    if !ENV["BASIC_AUTH"] then return end
    authenticate_or_request_with_http_basic do |username, password|
      (username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]) # ||(username == ENV["BASIC_AUTH_ADMIN_USER"] && password == ENV["BASIC_AUTH_ADMIN_PASSWORD"])

      # username == "user" && password == "pass"
    end
  end
  def basic_auth_admin
    if !ENV["BASIC_AUTH"] then return end
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_ADMIN_USER"] && password == ENV["BASIC_AUTH_ADMIN_PASSWORD"]
      # username == "use" && password == "pas"
    end
  end



  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_id, :email, :password, :password_confirmation, :name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_id, :email, :password, :remember_me])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_id, :email, :password, :password_confirmation, :current_password, :name])
  end
end
