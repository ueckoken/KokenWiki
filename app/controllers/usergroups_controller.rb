class UsergroupsController < ApplicationController
  layout "settings"

  def index
    @usergroups = Usergroup.accessible_by(current_ability, :read).includes(:users)
  end

  def new
    authorize! :create, Usergroup
    @users = User.all
  end

  def create
    authorize! :create, Usergroup
    usergroup = current_user.create_groups.build(usergroup_params)
    respond_to do |format|
      if usergroup.save
        format.html { redirect_to usergroup, notice: "Usergroup was successfully created." }
        format.json { render :show, status: :created, location: usergroup }
      else
        flash[:errors] = usergroup.errors.full_messages
        format.html { redirect_to new_usergroup_path }
        format.json { render json: usergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @usergroup = Usergroup.find(params[:id])
    authorize! :read, @usergroup
  end

  def edit
    @usergroup = Usergroup.find(params[:id])
    authorize! :write, @usergroup
    @users = User.all
  end

  def update
    @usergroup = Usergroup.find(params[:id])
    authorize! :write, @usergroup
    update_succeeded = @usergroup.update(usergroup_params)
    respond_to do |format|
      if update_succeeded
        format.html { redirect_to @usergroup, notice: "Usergroup was successfully updated." }
        format.json { render :show, status: :ok, location: @usergroup }
      else
        flash[:errors] = @usergroup.errors.full_messages
        format.html { redirect_to edit_usergroup_path }
        format.json { render json: @usergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @usergroup = Usergroup.find(params[:id])
    authorize! :write, @usergroup
    @usergroup.destroy!

    respond_to do |format|
      format.html { redirect_to usergroups_url, notice: "Usergroup was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def usergroup_params
      params.require(:usergroup).permit(:name, user_ids: [])
    end
end
