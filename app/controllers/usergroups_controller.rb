class UsergroupsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => :create

  def index
    @users = User.all
  end
  def new
    @users = User.all
  end
  def create
    usergroup_param = params.require(:usergroup).permit(:name, user_ids: [])
    name = usergroup_param[:name]
    usergroup = Usergroup.new(
      create_user: current_user,
      name: name
    )
    users = User.where(id: usergroup_param[:user_ids])

    authorize! :create, usergroup
    if users.size === 0
      raise ActiveRecord::RecordNotFound	
    end

    usergroup.users = users

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
  end
  def edit
    @users = User.all
  end
  def update
    users = User.where(id: params[:usergroup][:user_ids])

    if users.size == 0
      raise ActiveRecord::RecordNotFound	
    end

    @usergroup.users = users

    respond_to do |format|
      format.html { redirect_to @usergroup, notice: 'Usergroup was successfully updated.' }
      format.json { render :show, status: :ok, location: @usergroup }
    end
  end
  def destroy
    @usergroup.destroy!

    respond_to do |format|
      format.html { redirect_to usergroups_url, notice: 'Usergroup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  private
    def update_params
      params.require(:usergroup).permit(user_ids: [])
    end
end