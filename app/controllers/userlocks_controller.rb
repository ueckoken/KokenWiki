class UserlocksController < ApplicationController
  authorize_resource class: :userlock

  def create
    user = User.find_by(id: params[:user_id])
    if user == current_user
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You cannot lock yourself." }
      end
      return
    end
    user.lock_access!
    respond_to do |format|
      format.html { redirect_to users_path, notice: "#{user.name} was successfully locked." }
    end
  end

  def delete
    user = User.find_by(id: params[:user_id])
    if user == current_user
      respond_to do |format|
        format.html { redirect_to users_path, alert: "You cannot unlock yourself." }
      end
      return
    end
    user.unlock_access!
    respond_to do |format|
      format.html { redirect_to users_path, notice: "#{user.name} was successfully unlocked." }
    end
  end
end
