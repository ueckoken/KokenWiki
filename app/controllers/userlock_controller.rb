
class UserlockController < ApplicationController
  before_action :authenticate_user!
  def index
    if ! current_user.is_admin?
      raise ActionController::RoutingError
      return
    end
    @users = User.all.order("locked_at DESC")
  end
  def update
    if ! current_user.is_admin?
      raise ActionController::RoutingError
      return
    end
    user = User.find_by(id: params[:user_id].to_i)
    if user == current_user
      redirect_to action: "index"
      return
    end
    if params[:lock] == "true" && !user.access_locked?
      user.lock_access!
    elsif params[:lock] == "false" && user.access_locked?
      user.unlock_access!
    end
    redirect_to action: "index"
  end
end
