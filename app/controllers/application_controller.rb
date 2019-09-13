class ApplicationController < ActionController::Base
    
  def basic_auth
    if(!ENV["BASIC_AUTH"])then return end
    authenticate_or_request_with_http_basic do |username, password|
      (username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"])||(username == ENV["BASIC_AUTH_ADMIN_USER"] && password == ENV["BASIC_AUTH_ADMIN_PASSWORD"])
      
      #username == "user" && password == "pass"
    end
  end
  def basic_auth_admin
    if(!ENV["BASIC_AUTH"])then return end
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_ADMIN_USER"] && password == ENV["BASIC_AUTH_ADMIN_PASSWORD"]
      #username == "use" && password == "pas"
    end
  end
end
