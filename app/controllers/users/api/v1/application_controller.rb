module Api
  module V1
    class ApplicationController < ActionController::API # Note: here is not ::BASE
      include DeviseTokenAuth::Concerns::SetUserByToken
      protect_from_forgery with: :null_session
    end
  end
end

