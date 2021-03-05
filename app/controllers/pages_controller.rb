require "pathname"
require "webrick/httputils"

class PagesController < ApplicationController
  include PathHelper
  # before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :force_trailing_slash, only: [:show_page]

  def show_search
    if params[:search] == ""
      @search_pages = Page.none

      render "search"
      return
    end
    @search_pages = Page.accessible_by(current_ability, :read)

    searchstr = params[:search].split
    searchstr.each do |str|
      @search_pages = @search_pages.search(str)
    end

    render "search"
  end

  def render_pankuzu_list(page)
    if page == nil
      return Page.none
    end
    return render_pankuzu_list(page.parent) + [page]
  end

  def render_left
    if is_root_path?(@pathname)
      if @page == nil
        @brothers_pages = Page.none
        @children_pages = Page.none
        return
      end
      @brothers_pages = Page.none
      @children_pages = Page.accessible_by(current_ability, :read).where(parent: @page).order(:title)
      return
    end
    if @page != nil
      @parent_page = @page.parent
    else
      parent_pathname = @pathname.parent
      @parent_page = Page.find_by(path: parent_pathname.to_s)
    end
    # parent shold not null
    @brothers_pages = Page.accessible_by(current_ability, :read).where(parent: @parent_page).where.not(id: @page.id).order(:title)
    if @page != nil
      @children_pages = Page.accessible_by(current_ability, :read).where(parent: @page).order(:title)
    else
      @children_pages = Page.none
    end
  end

  def render_right
    one_month_ago = Time.current.ago(1.month)
    current_timezone = Time.zone.formatted_offset
    @updated_pages = Page.accessible_by(current_ability, :read).where("updated_at > ?", one_month_ago).order(updated_at: :desc).select("DATE(CONVERT_TZ(updated_at, 'UTC', '#{current_timezone}')) as updated_date, path").limit(50)
  end

  # index
  def show_page
    @pathname = get_formal_pathname params[:pages]
    @path = @pathname.to_s
    @page = Page.find_by(path: @path)
    if @page.nil?
      parent_pathname = @pathname.parent
      parent = Page.find_by(path: parent_pathname.to_s)

      if !is_root_path?(@pathname)
        if parent.nil?
          raise ActiveRecord::RecordNotFound
        end
        authorize! :write, parent
      end

      @title = get_title @pathname
      @pankuzu = render_pankuzu_list parent
      @page = Page.new(title: @title, path: @path, parent: parent)

      render_left
      render_right
      render "new"
      return
    end

    authorize! :read, @page

    @update_histories = @page.update_histories.order(created_at: :desc)
    @title = @page.title
    @pankuzu = render_pankuzu_list @page.parent

    @attached_files = []
    @page.files.each do |file|
       filename = file.blob.filename.to_s
       path = (@pathname / filename).to_s
       escaped_path = WEBrick::HTTPUtils.escape(path)
       created_at = file.created_at

       @attached_files.append({
         :filename => filename,
         :path => path,
         :escaped_path => escaped_path,
         :created_at => created_at
       })
    end

    render_right
    render_left
    render "show"
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json

  def create
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    parent_pathname = pathname.parent
    parent = Page.find_by(path: parent_pathname.to_s)
    title = get_title pathname

    if !Page.exists?(path: path) && (parent != nil || is_root_path?(pathname))
      @page = Page.new(
        user: current_user,
        content: "new page",
        title: title,
        path: path,
        parent: parent,
        )
    else
      raise MajorError.bad_request
    end


    respond_to do |format|
      if @page.save
        format.html { redirect_back fallback_location: path, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json

  # updateはpageのみ
  def update
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    @page = Page.find_by(path: path)

    if @page == nil
      raise ActiveRecord::RecordNotFound
      return
    end
    authorize! :write, @page

    page_params = params.require(:page).permit(:content, :editable_group_id, :readable_group_id)
    success_flag = @page.update(
      user: current_user,
      content: page_params[:content],
      readable_group: current_user.usergroups.find_by(id: page_params[:readable_group_id]),
      editable_group: current_user.usergroups.find_by(id: page_params[:editable_group_id]),
    )
    respond_to do |format|
      if success_flag
        history = UpdateHistory.new(user: @page.user, content: @page.content)
        @page.update_histories << history
        format.html { redirect_to path, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Page was not updated, something wrong' }
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json

  def destroy
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by(path: path)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :write, page

    if page.children.size != 0
      raise ActiveRecord::RecordNotFound
    end

    page.destroy!

    respond_to do |format|
      format.html { redirect_to path, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.fetch(:page, {})
  end
end
