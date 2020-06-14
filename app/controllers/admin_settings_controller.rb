class AdminSettingsController < ApplicationController
  authorize_resource :class => :admin_user

  def index
    @users = User.all.order("is_admin DESC")
  end
  def update
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
end
