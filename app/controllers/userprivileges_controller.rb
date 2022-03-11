class UserprivilegesController < ApplicationController
  authorize_resource class: :userprivilege

  def create
    user = User.find_by(id: params[:user_id])
    if user == current_user
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You cannot privilege yourself." }
      end
      return
    end
    user.update(is_admin: true)
    respond_to do |format|
      format.html { redirect_to users_path, notice: "#{user.name} was successfully privileged." }
    end
  end

  def delete
    user = User.find_by(id: params[:user_id])
    if user == current_user
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You cannot unprivilege yourself." }
      end
      return
    end
    user.update(is_admin: false)
    respond_to do |format|
      format.html { redirect_to users_path, notice: "#{user.name} was successfully unprivileged." }
    end
  end
end
