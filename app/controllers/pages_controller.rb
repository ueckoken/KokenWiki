class PagesController < ApplicationController
  #before_action :set_page, only: [:show, :edit, :update, :destroy]

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
    #elsif(params[:new]!=nil)
    #  new
    #  render :action=>"new"
    #  return
    #elsif(params[:edit]!=nil)
    #  edit
      #render :action=>"edit"
    #  return
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

  #index
  def page_show
    path = get_formal_path params[:pages]
    @page = Page.find_by(path: path)
    #render "show"
    #return
    if @page != nil
      render "show"
    else
      parent = get_parent_path path
      parent = Page.find_by(path:parent)
      if parent == nil && path != ""
        raise ActiveRecord::RecordNotFound
      end
      #if parent is not found, render 404 
      #render createnewpage
      @page = Page.new(title:get_title(params[:pages]))
      render "new"
    end
  end

  def file_show
    path = params[:pages]
    #filename以外のpathを取得
    filename = get_title path
    path = get_parent_path path
    filename += params[:file]
    page = Page.find_by(path: path)
    file = page.files.attatchment
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
        #user: current_user,
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
    path = get_formal_path params[:path]
    page = Page.find_by(path: path)
    if page == nil
      raise ActiveRecord::RecordNotFound
    end
    comment_param = params.require(:comment).permit(:content)
    success_flag = true
    if is_readable? page
      comment = Comment.create(
        #user: current_user,
        page: page,
        comment: comment_param[:content],
      )
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path, notice: 'Comment was successfully createed.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Comment was not created, something wrong'}
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_file

  end
  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json

  #updateはpageのみ
  def update
    path = get_formal_path params[:pages]
    @page = Page.find_by(path:path)
    if @page == nil 
      raise ActiveRecord::RecordNotFound
      return
    end
    user_params = params.require(:page).permit(:content, :editable_group_id, :readable_group_id)
    success_flag = true
    if is_editable? @page
      success_flag = @page.update(
        #user: current_user,
        content: user_params[:content],
        #editable_group: Usergroup.find(user_params[:editable_group_id]),
        #readable_group: Usergroup.find(user_params[:editable_group_id]),
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
    if params[:format] != nil
      destroy_file
    elsif params[:comment_id] != nil
      destroy_comment
    else
      destroy_page
    end

  end
  def destroy_page
    path = get_formal_path params[:pages]
    page = Page.find_by(path: path)
    if page == nil || page.children.size != 0
      raise ActiveRecord::RecordNotFound
    end
    page.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: 'Page was successfully destroyed.' }
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
      return true
    end
    def is_readable? page
      if page == nil
        return false
      end
      return true
    end
end
