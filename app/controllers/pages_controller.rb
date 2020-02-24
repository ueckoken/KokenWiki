require "pathname"

class PagesController < ApplicationController
  include PathHelper
  # before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :force_trailing_slash
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def filter_readable_pages(pages)
    if current_user.is_admin?
      return pages
    end
    readable_pages = []
    pages.each do |page|
      if page.is_readable_user?(current_user)
        readable_pages += [page]
      end
    end
    return readable_pages
  end
  def get_readable_pages
    pages = Page.where(is_public: true, is_draft: false)
    if !user_signed_in?
      return pages
    end
    pages = pages.or(Page.where(readable_group: nil, is_draft: false))
    if current_user != nil
      current_user.usergroups.each do |id|
        pages = pages.or(Page.where(readable_group: id, is_draft: false))
      end
    end
    pages = pages.or(Page.where(is_draft: true, user: current_user))
    return pages
  end
  def show_search
    # とりあえずの表示
    @pathname = get_formal_pathname params[:pages]
    @path = @pathname.to_s
    @page = Page.find_by(path: @path)
    @title = get_title @pathname
    if @page != nil
      @pankuzu = render_pankuzu_list @page.parent
    else
      @pankuzu = []
    end
    @search_pages = get_readable_pages
    if params[:search] != ""
      searchstr = params[:search].split
      @search_pages = @search_pages.where("path LIKE ?", @path + "%")
      @search_pages = @search_pages.where("CONCAT(title,content) LIKE ?", "%" + searchstr.pop + "%")
      searchstr.each do |str|
        @search_pages = @search_pages.where("CONCAT(title,content) LIKE ?", "%" + str + "%")
      end
    else
      @search_pages = []
    end

    render_left
    render_right
    render "search"
  end

  def render_pankuzu_list(page)
    if page == nil
      return []
    end
    return render_pankuzu_list(page.parent) + [page]
  end

  def render_left
    if is_root_path?(@pathname)
      if @page == nil
        @brothers_pages = []
        @children_pages = []
        return
      end
      @brothers_pages = filter_readable_pages [@page]
      @children_pages = filter_readable_pages @page.children.order(:title)
      return
    end
    if @page != nil
      parent = @page.parent
    else
      parent_pathname = @pathname.parent
      parent = Page.find_by(path: parent_pathname.to_s)
    end
    # parent shold not null
    @brothers_pages = parent.children.order(:title)
    if @page != nil
      @children_pages = @page.children.order(:title)
    else
      @children_pages = []
    end
    @brothers_pages = filter_readable_pages @brothers_pages
    @children_pages = filter_readable_pages @children_pages
  end

  def render_right
    begin
      # tmp_pages = Page.all.order("updated_at DESC").select(:readable_group_id,:is_draft,:updated_at,:path,:user_id)
      # @updated_pages = []
      # tmp_pages.each do |page|
      #  if @updated_pages.size >= 50
      #    break
      #  end
      #  if is_readable? page
      #    @updated_pages += [page]
      #  end
    end
    # @updated_pages = get_readable_pages().limit(50).order("updated_at DESC").select(:readable_group_id,:is_draft,:is_public,:updated_at,:path,:user_id)
    @updated_pages = filter_readable_pages(Page.order("updated_at DESC").select(:readable_group_id, :is_draft, :is_public, :updated_at, :path, :user_id).limit(50))
  end

  # index
  def show_page
    @pathname = get_formal_pathname params[:pages]
    @path = @pathname.to_s
    @page = Page.find_by(path: @path)
    if @page.nil?
      parent_pathname = @pathname.parent
      parent = Page.find_by(path: parent_pathname.to_s)
      if (parent.nil? || !parent.is_readable_user?(current_user)) && !is_root_path?(@pathname)
        # 見えない人は下部ページ作れないでいいよね
        # if !user_signed_in?
        #  authenticate_user!
        # else
        raise ActiveRecord::RecordNotFound
        # end
      end
      # if parent is not found, render 404
      # render createnewpage
      if not user_signed_in?
        raise ActiveRecord::RecordNotFound
      end

      @title = get_title @pathname
      @pankuzu = render_pankuzu_list parent
      @page = Page.new(title: @title, path: @path, parent: parent)
      render_left
      render_right
      render "new"
      return
    end

    if not @page.is_readable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end

    @update_histories = @page.update_histories.order(created_at: :desc)
    @title = @page.title
    @pankuzu = render_pankuzu_list @page.parent
    @editable = @page.is_editable_user?(current_user)
    @update_histories = @page.update_histories.order("created_at DESC")

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
        is_draft: false,
        is_public: false
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
    if @page == nil || !@page.is_editable_user?(current_user)
      raise ActiveRecord::RecordNotFound
      return
    end
    page_params = params.require(:page).permit(:content, :editable_group_id, :readable_group_id, :is_draft, :is_public)
    success_flag = true
    if @page.is_editable_user?(current_user)
      success_flag = @page.update(
        user: current_user,
        content: page_params[:content],
        readable_group: current_user.usergroups.find_by(id: page_params[:readable_group_id]),
        editable_group: current_user.usergroups.find_by(id: page_params[:editable_group_id]),
        is_draft: page_params[:is_draft],
        is_public: page_params[:is_public]
      )
    else
      success_flag = false
    end
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
    if page == nil || page.children.size != 0 || !page.is_editable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    page.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # private
  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.fetch(:page, {})
  end
end
