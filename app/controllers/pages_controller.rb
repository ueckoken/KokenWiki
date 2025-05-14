require "pathname"
require "webrick/httputils"

class PagesController < ApplicationController
  include PathHelper
  # before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :force_trailing_slash, only: [:show_page]
  helper_method :sort_link

  def show_search
    if @search.invalid?
      if @search.errors.include?(:order)
        redirect_to search_path(sort_link(order: "best_match"))
        return
      elsif @search.errors.include?(:period)
        redirect_to search_path(sort_link(period: -1))
        return
      elsif @search.errors.include?(:target)
        redirect_to search_path(sort_link(target: "content"))
        return
      elsif @search.errors.include?(:mode)
        redirect_to search_path(sort_link(mode: "natural_language"))
        return
      end
    end

    if @search.query.blank?
      @search_pages = Page.none
    else
      case @search.mode
      when "natural_language"
        @search_pages = Page.accessible_by(current_ability, :read).search(@search.target, @search.query)
      when "slower_stricter"
        @search_pages = Page.accessible_by(current_ability, :read).stricter_slow_search(@search.target, @search.query)
      end
    end

    if @search.period != -1
      end_datetime = Time.now
      start_datetime = end_datetime.ago(@search.period)
      @search_pages = @search_pages.where(updated_at: start_datetime...end_datetime)
    end
    case @search.order
    when "updated_at_asc"
      @search_pages = @search_pages.order(updated_at: :asc)
    when "updated_at_desc"
      @search_pages = @search_pages.order(updated_at: :desc)
    end
    render "search"
  end

  def render_pankuzu_list
    @pankuzu = @page.self_and_ancestors.reverse
  end

  def render_left
    if @page.root?
      @brothers_pages = Page.none
    else
      @brothers_pages = Page.accessible_by(current_ability, :read).where(parent: @page.parent).where.not(id: @page.id).order(:title)
    end
    if @page.persisted?
      @children_pages = Page.accessible_by(current_ability, :read).where(parent: @page).order(:title)
    else
      # new page but not saved to database has no children
      @children_pages = Page.none
    end
  end

  def render_right
    ttl = Time.current.ago(2.weeks)
    current_timezone = Time.zone.formatted_offset
    @updated_pages = Page.accessible_by(current_ability, :read).where("updated_at > ?", ttl).order(updated_at: :desc).select("DATE(CONVERT_TZ(updated_at, 'UTC', '#{current_timezone}')) as updated_date, id, parent_id, title").limit(20)
  end

  # index
  def show_page
    pathname = get_formal_pathname params[:pages]
    @page = Page.find_by_pathname(pathname)

    if @page.nil?
      parent_pathname = pathname.parent
      parent = Page.find_by_pathname(parent_pathname)

      if !is_root_path?(pathname)
        if parent.nil?
          raise ActiveRecord::RecordNotFound
        end
        authorize! :write, parent
      end

      title = get_title pathname
      @page = Page.new(title: title, parent: parent)

      render_pankuzu_list
      render_left
      render_right
      render "new"
      return
    end

    authorize! :read, @page

    @update_histories = @page.update_histories.order(created_at: :desc)

    descendants = @page.self_and_descendants.pluck(:id)
    next_parent_pages = Page.accessible_by(current_ability, :read)
      .where.not(id: descendants)
    # ActiveRecord だと path を参照するたびに内部的にクエリが呼ばれて良くない
    # ActiveRecord を捨てる代わりに 単一のクエリで path を得る
    @next_parents = Page.get_paths_by_ids(next_parent_pages.pluck(:id)).sort_by { |page| page["path"] }

    render_pankuzu_list
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
    parent = Page.find_by_pathname(parent_pathname)
    title = get_title pathname

    if Page.find_by_pathname(pathname).nil? && (parent != nil || is_root_path?(pathname))
      @page = Page.new(
        user: current_user,
        title: title,
        parent: parent,
        )
    else
      raise MajorError.bad_request
    end


    respond_to do |format|
      if @page.save
        format.html { redirect_back fallback_location: path, notice: "Page was successfully created." }
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
    @page = Page.find_by_pathname(pathname)

    if @page == nil
      raise ActiveRecord::RecordNotFound
      return
    end
    authorize! :write, @page

    page_params = params.require(:page).permit(:title, :content, :editable_group_id, :readable_group_id, :parent_page_id)
    update_succeeded = @page.update(
      user: current_user,
      title: page_params[:title],
      content: page_params[:content],
      readable_group: current_user.usergroups.find_by(id: page_params[:readable_group_id]),
      editable_group: current_user.usergroups.find_by(id: page_params[:editable_group_id]),
      parent_id: page_params[:parent_page_id]
    )
    respond_to do |format|
      if update_succeeded
        history = UpdateHistory.new(user: @page.user, content: @page.content)
        if @page.saved_changes?
          @page.update_histories << history
          Rails.logger.info "Page #{@page.id} was updated by #{current_user.name}, or #{@page.user.name}. Webhook will be triggered."
        end
        format.html { redirect_to @page.path, notice: "Page was successfully updated." }
        format.json { render :show, status: :ok, location: path }
      else
        flash[:errors] = @page.errors.full_messages
        format.html { redirect_back fallback_location: pathname.to_s, alert: "Page was not updated, something wrong" }
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json

  def destroy
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by_pathname(pathname)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :write, page

    if page.children.size != 0
      raise ActiveRecord::RecordNotFound
    end

    page.destroy!

    respond_to do |format|
      format.html { redirect_to path, notice: "Page was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # add new params to current params
  # build new params
  def sort_link(params_to_add)
    # .attributes works like .to_hash
    return @search.attributes.with_indifferent_access.merge(params_to_add)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_params
    params.fetch(:page, {})
  end
end
