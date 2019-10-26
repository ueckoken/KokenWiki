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
      show_search
      return
    elsif params[:format]==nil
      show_page
    else
      show_file
    end
  end

  def filter_readable_pages pages
    if is_admin? current_user
      return pages
    end
    readable_pages = []
    pages.each do |page|
      if is_readable? page
      readable_pages += [page]
      end
    end
    return readable_pages
  end
  def get_readable_pages
    pages = Page.where(is_public:true,is_draft:false)
    if !user_signed_in?
      return pages
    end
    pages=pages.or(Page.where(readable_group:nil,is_draft:false))
    if current_user != nil
      current_user.usergroups.each do |id|
        pages=pages.or(Page.where(readable_group:id,is_draft:false))
      end
    end
    pages = pages.or(Page.where(is_draft:true,user:current_user))
    return pages
    
  end
  def show_search

    #とりあえずの表示
    @path = get_formal_path params[:pages]
    @page = Page.find_by(path: @path)
    @title = get_title @path
    if @page != nil
      @pankuzu = render_pankuzu_list @page.parent
    else
      @pankuzu = []
    end
    @search_pages = get_readable_pages
    if(params[:search]!="")
      searchstr= params[:search].split
      @search_pages=@search_pages.where("path LIKE ?", @path+"%")
      @search_pages=@search_pages.where("CONCAT(title,content) LIKE ?", "%"+searchstr.pop+"%")
      searchstr.each do |str|
        @search_pages=@search_pages.where("CONCAT(title,content) LIKE ?", "%"+str+"%")
      end
    else
      @search_pages=[]
    end

    render_left
    render_right
    render "search"
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
      @brothers_pages = filter_readable_pages @brothers_pages
      @children_pages = filter_readable_pages @children_pages
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
    @brothers_pages = filter_readable_pages @brothers_pages
    @children_pages = filter_readable_pages @children_pages
  end

  def render_right
    begin
    #tmp_pages = Page.all.order("updated_at DESC").select(:readable_group_id,:is_draft,:updated_at,:path,:user_id)
    #@updated_pages = []
    #tmp_pages.each do |page|
    #  if @updated_pages.size >= 50
    #    break
    #  end
    #  if is_readable? page
    #    @updated_pages += [page]
    #  end
    end
    #@updated_pages = get_readable_pages().limit(50).order("updated_at DESC").select(:readable_group_id,:is_draft,:is_public,:updated_at,:path,:user_id)
    @updated_pages = filter_readable_pages(Page.order("updated_at DESC").select(:readable_group_id,:is_draft,:is_public,:updated_at,:path,:user_id).limit(50))
  end

  #index
  def show_page
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
        #if !user_signed_in?
        #  authenticate_user!
        #else
          raise ActiveRecord::RecordNotFound
        #end
      end
    else
      parent = get_parent_path @path
      parent = Page.find_by(path:parent)
      if (parent == nil|| !is_readable?(parent)) && @path != ""
        #見えない人は下部ページ作れないでいいよね
        #if !user_signed_in?
        #  authenticate_user!
        #else
        raise ActiveRecord::RecordNotFound
        #end
      end
      #if parent is not found, render 404 
      #render createnewpage
      if user_signed_in?
        @pankuzu = render_pankuzu_list parent
        @page = Page.new(title:get_title(params[:pages]))
        render_left
        render_right
        render "new"
        return
      else
        #if get_formal_path(params[:pages]) == ""
        #authenticate_user!
        #else
        raise ActiveRecord::RecordNotFound
        #end
      end
    end
  end

  def show_file
    path = params[:pages]
    #filename以外のpathを取得
    filename = get_title path
    path = get_parent_path path
    filename += "." + params[:format]
    page = Page.find_by(path: path)
    if (page == nil || !is_readable?(page))
      raise ActiveRecord::RecordNotFound
    end
    file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:filename})
    if file == nil
      raise ActiveRecord::RecordNotFound
    else
      if file.blob.image? || file.blob.audio? || file.blob.video?
        send_data file.blob.download, type: file.blob.content_type, disposition: 'inline'
      else
        send_data file.blob.download, type: file.blob.content_type, disposition: 'attachment'
      end
    end
  end

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
        is_draft: false,
        is_public: false
        )
    else
      raise MajorError::bad_request
    end


    respond_to do |format|
      if @page.save
        format.html { redirect_back fallback_location: path + "/", notice: 'Page was successfully created.' }
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
        format.html { redirect_to path + "/", notice: 'Comment was successfully createed.' }
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
        filename = file.original_filename.to_s
        
        prev_file = page.files.joins(:blob).find_by(active_storage_blobs:{filename:filename})
        if prev_file != nil
          prev_file.purge
        end
  
        if filename.include?(".") && !filename.include?("?") && !filename.include?("/")
          page.files.attach file
        end
      end
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path + "/", notice: 'Files were successfully uploaded.' }
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
    page_params = params.require(:page).permit(:content, :editable_group_id, :readable_group_id, :is_draft, :is_public)
    success_flag = true
    if is_editable? @page
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
        history = UpdateHistory.new(user:@page.user,content:@page.content)
        @page.update_histories<<history
        format.html { redirect_to path + "/", notice: 'Page was successfully updated.' }
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
      format.html { redirect_to path + "/", notice: 'Page was successfully destroyed.' }
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
      format.html { redirect_to path + "/", notice: 'Comment was successfully destroyed.' }
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
      file.purge
    end
    
    redirect_to path + "/", notice: 'File was successfully destroyed.'
    
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
      if page.editable_group == nil
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
      if page.is_draft
        if current_user == page.user
          return true
        else
          return false
        end
      end
      if page.is_public
        return true
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
