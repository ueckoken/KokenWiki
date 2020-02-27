class AdminSettingsController < ApplicationController
  before_action :authenticate_user!
  def index
    if ! current_user.is_admin?
      error_404
      return
    end
    @users = User.all.order("is_admin DESC")
  end
  def update
    if ! current_user.is_admin?
      error_404
      return
    end
    user = User.find_by(id: params[:user_id])
    if user == current_user
      redirect_to action: "index"
      return
    end
    if params[:admin] == "true" && !user.is_admin?
      user.update(is_admin: true)
    elsif params[:admin] == "false" && user.is_admin?
      user.update(is_admin: false)
    end
    redirect_to action: "index"
  end
  def error_404
    raise ActionController::RoutingError, params[:pages] # とりあえず404なげる（めんどい）
  end
end
