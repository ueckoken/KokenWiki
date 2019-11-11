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
    url = request.original_url
    url_ = url.split("?")
    if url_.size > 1
      option = url_.pop
    end
    if option != "" && option != nil
      option = "?" + option
    end
    url_body = url_.join
    if url_body == nil
      url_body = ""
    end
    redirecturl = url_body
    redirecturl += "/" unless url_body.match?(/\/$/)
    if option != nil
      redirecturl += option
    end
    if redirecturl != url
      redirect_to redirecturl
      return true
    else
      return false
    end
  end

  def is_admin?(user)
    if user == nil
      return false
    end
    if user.is_admin
      return true
    end
    return false
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
