class PagesController < ApplicationController
  #before_action :set_page, only: [:show, :edit, :update, :destroy]
  #before_action :force_trailing_slash
  # settings/以外のgetで呼ばれる
  # paramによって処理を分ける
  #　?search 検索
  #　?new   新規ページ作成
  #　?edit 既存ページ編集
  #　?format /[.]/があった時 ファイル表示
  # それらの要素がなかった時 ページ表示
  def show_route
    if(params[:search]!=nil)
      search_show
      return
    elsif params[:format]==nil
      
      if(get_formal_path(params[:pages]) == nil)
        #redirect_404
        return
      end
      page_show
    else
      file_show
      #render :nothing=>true and return
    end
  end

  def search

  end

  def render_pankuzu_list page
    if page==nil
      return []
    end
    return render_pankuzu_list(page.parent) + [page]
  end

  def render_left
    path = get_formal_path params[:pages]
    parent_path = get_parent_path path
    page = Page.find_by(path: path)
    if path == ""
      if page == nil
        @brothers_pages = []
        @children_pages = []
      else
        @brothers_pages = [page]
        @children_pages = page.children
      end
      return
    end
    if page != nil
      parent = page.parent
    else
      parent = Page.find_by(path: parent_path)
    end
    # parent shold not null
    @brothers_pages = parent.children
    if page != nil
      @children_pages = page.children
    else
      @children_pages = []
    end
  end

  def render_right
    tmp_pages = Page.all.order("updated_at DESC").select(:readable_group_id,:is_draft,:updated_at,:path,:user_id)
    @updated_pages = []
    tmp_pages.each do |page|
      if @updated_pages.size >= 50
        break
      end
      if is_readable? page
        @updated_pages += [page]
      end
    end
  end

  #index
  def page_show
    if force_trailing_slash
      return
    end
    @path = get_formal_path params[:pages]
    @page = Page.find_by(path: @path) 
    @title = get_title @path
    #render "show"
    #return
    if @page != nil
      if is_readable? @page
        @pankuzu = render_pankuzu_list @page.parent
        @editable = is_editable?(@page)
        render_right
        render_left
        render "show"
        return
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      parent = get_parent_path @path
      parent = Page.find_by(path:parent)
      if parent == nil && @path != ""
        raise ActiveRecord::RecordNotFound
      end
      #if parent is not found, render 404 
      #render createnewpage
      #if user_signed_in?
        @pankuzu = render_pankuzu_list parent
        @page = Page.new(title:get_title(params[:pages]))
        render_left
        render_right
        render "new"
        return
      #else
      #  raise ActiveRecord::RecordNotFound
      #end
    end
  end

  def file_show
    path = params[:pages]
    #filename以外のpathを取得
    filename = get_title path
    path = get_parent_path path
    filename += "." + params[:format]
    page = Page.find_by(path: path)
    if (page == nil || !is_readable?(page))
      raise ActiveRecord::RecordNotFound
    end
    file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:filename}).blob
    if file == nil
      raise ActiveRecord::RecordNotFound
    else
      send_data file.download
    end
  end
  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  #def new
  #  @page = Page.new(title:get_title(params[:pages]))
  #end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json

  def create_route
    authenticate_user!
    if params[:file] != nil
      create_file
    elsif params[:comment] != nil
      create_comment
    else
      create_page
    end
  end

  def create_page
    path = get_formal_path params[:pages]
    parent = get_parent_path path
    parent = Page.find_by(path: parent)
    title = get_title path
    if Page.find_by(path: path) == nil &&(parent != nil || path == "")
      @page = Page.new(
        user: current_user,
        content:"new page",
        title: title,
        path: path,
        parent: parent,
        is_draft: true
        )
    else
      raise MajorError::bad_request
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

  def create_comment
    path = get_formal_path params[:pages]
    page = Page.find_by(path: path)
    if (page == nil || !is_readable?(page))
      raise ActiveRecord::RecordNotFound
    end
    comment_param = params.require(:comment).permit(:content)
    success_flag = true
    if is_readable? page
      comment = Comment.create(
        user: current_user,
        page: page,
        comment: comment_param[:content],
      )
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        puts path
        format.html { redirect_to path, notice: 'Comment was successfully createed.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Comment was not created, something wrong'}
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_file
    path = get_formal_path params[:pages]
    page = Page.find_by(path: path)
    if (page == nil || !is_readable?(page))
      raise ActiveRecord::RecordNotFound
    end
    file_param = params.require(:file).permit(files:[])
    success_flag = true
    if is_editable? page
      file_param["files"].each do |file|
        #binding.pry
        filename = file.original_filename
        
        prev_file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:filename})
        if prev_file != nil
          prev_file.destroy
        end

        if file.original_filename.include?(".")
          page.files.attach file
        end
      end
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path, notice: 'Files were successfully uploaded.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Files were not updated, something wrong'}
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end

  end
  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json

  #updateはpageのみ
  def update
    path = get_formal_path params[:pages]
    @page = Page.find_by(path:path)
    if (@page == nil || !is_editable?(@page))
      raise ActiveRecord::RecordNotFound
      return
    end
    user_params = params.require(:page).permit(:content, :editable_group_id, :readable_group_id)
    success_flag = true
    puts(current_user.usergroups.find_by(id:user_params[:readable_group_id]))
    
    if is_editable? @page
      success_flag = @page.update(
        user: current_user,
        content: user_params[:content],
        readable_group: current_user.usergroups.find_by(id: user_params[:readable_group_id]),
        editable_group: current_user.usergroups.find_by(id: user_params[:editable_group_id]),
        #is_draft: params,
      )
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Page was not updated, something wrong'}
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy_route
    authenticate_user!
    if params[:format] != nil
      destroy_file
    elsif params[:comment] != nil
      destroy_comment
    else
      destroy_page
    end

  end
  def destroy_page
    path = get_formal_path params[:pages]
    page = Page.find_by(path: path)
    if (page == nil || page.children.size != 0 || !is_editable?(page))
      raise ActiveRecord::RecordNotFound
    end
    page.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def destroy_comment
    path = get_formal_path params[:pages]
    page = Page.find_by(path: path)
    if (page == nil)
      raise ActiveRecord::RecordNotFound
    end
    comment_param = params.require(:comment).permit(:comment_id)
    comment = page.comments.find(comment_param[:comment_id])
    if (is_editable?(page) || comment.user == current_user)
      comment.destroy
    else
      #not permittedを返した方が…？
      raise ActiveRecord::RecordNotFound
    end
    respond_to do |format|
      format.html { redirect_to path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_file
    path = params[:pages]
    #filename以外のpathを取得
    filename = get_title path
    path = get_parent_path path
    filename += "." + params[:format]
    page = Page.find_by(path: path)
    if (page == nil || !is_editable?(page))
      raise ActiveRecord::RecordNotFound
    end
    file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:filename})
    if file == nil
      raise ActiveRecord::RecordNotFound
    else
      file.destroy
    end
    respond_to do |format|
      format.html { redirect_to path, notice: 'File was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  #private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.fetch(:page, {})
    end

    # "/" -> ""
    # "a/b" -> "/a/b"
    # "a/b/"-> "/a/b"
    def get_formal_path path
      if path == "" || path == "/" || path == nil
        return ""
      end
      if path[0] != "/"
        path = "/" + path
      end
      if path[path.size - 1] == "/"
        path = path[0,path.size - 1]
      end
      #"/a/b"の形になっていることが望まれる
      
      if (path.include?("//") ||
        path.include?("?") ||
        path.include?(".") ||
        path.start_with?("/rails") ||
        path.start_with?("/settings")) then
        return nil
      end
      return path

    end

    def get_parent_path path
      path = get_formal_path path
      if path == ""
        return nil
      end
      path_ = path.split("/")[0, path.size - 1]
      parent = path_[0, path_.size - 1].join("/")
      return parent
    end

    def get_title path
      path = get_formal_path path
      if path == ""
        return ""
      end
      path_ = path.split("/")
      title = path_[path_.size - 1]
      return title
    end

    def is_editable? page
      if page == nil
        return false
      end
      if !user_signed_in?
        return false
      end

      if is_admin? current_user
        return true
      end
      if page.is_draft
        if page.user == current_user
          return true
        else
          return false
        end
      end
      if page.readable_group == nil
        return true
      elsif page.editable_group.users.include? current_user
        return true
      else
        return false
      end
      return true
    end
    def is_readable? page
      if page == nil
        return false
      end
      if !user_signed_in?
        return false
      end

      if is_admin? current_user
        return true
      end
      if page.is_draft
        if page.user == current_user
          return true
        else
          return false
        end
      end
      if page.readable_group == nil
        return true
      elsif page.readable_group.users.include? current_user
        return true
      else
        return false
      end

      return true
    end
end
