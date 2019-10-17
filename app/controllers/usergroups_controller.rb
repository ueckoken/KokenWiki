class UsergroupsController < ApplicationController
  before_action :authenticate_user!
  def index
    force_trailing_slash
    @usergroups=Usergroup.all
    @users=User.all
  end
  def new
    @users=User.all
  end
  def create
    usergroup_param = params.require(:usergroup).permit(:name, check_id:[])
    name = usergroup_param[:name]
    if usergroup_param[:check_id].size<=1
      raise ActiveRecord::RecordNotFound
    end
    usergroup=Usergroup.new(
      create_user: current_user,
      name: name
    )
    usergroup_param[:check_id].each do |s|
      user = User.find_by(id:s.to_i)
      if user != nil
        usergroup.users<<user
      end
    end
    respond_to do |format|
      if usergroup.save
        format.html { redirect_to usergroup, notice: 'Usergroup was successfully created.' }
        format.json { render :show, status: :created, location: usergroup }
      else
        format.html { render :new }
        format.json { render json: usergroup.errors, status: :unprocessable_entity }
      end
    end
  end
  def show
    #force_trailing_slash
    id=params[:id]
    @usergroup=Usergroup.find(id.to_i)
    if is_editable? @usergroup
      @editable = true
    end
  end
  def edit
    id=params[:id]
    
    @usergroup=Usergroup.find(id.to_i)
    if !is_editable? @usergroup
      raise ActionController::RoutingError
      return
    end
    @users=User.all
  end
  def update
    usergroup=Usergroup.find(params[:id])
    if ! is_editable? usergroup
      raise  ActionController::RoutingError
      return
    end
    #usergroup.update(
    #  name:params[:usergroup][:name]
    #)
    usergroup_param = params.require(:usergroup).permit(check_id:[])
    if usergroup_param.size <= 1
      raise ActiveRecord::RecordNotFound
    end
    usergroup.users.clear
    usergroup_param[:check_id].each do |s|
      user =User.find_by(id:s.to_i)
      if(user)
        usergroup.users<<user
      end
    end
    respond_to do |format|
      format.html { redirect_to usergroup, notice: 'Usergroup was successfully updated.' }
      format.json { render :show, status: :ok, location: usergroup }
    end
  end
  def destroy
    id = params[:id]
    
    usergroup=Usergroup.find(id.to_i)
    if(is_editable? usergroup)
      usergroup.destroy!
    else

    end
    respond_to do |format|
      format.html { redirect_to usergroups_url, notice: 'Usergroup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def is_editable? usergroup
    if !user_signed_in?
      return false
    end
    if is_admin? current_user
      return true
    end
    if usergroup == nil
      return false
    end
    if ((usergroup.create_user == current_user)||(usergroup.users.include? current_user))
      return true
    end
    return false
  end
end