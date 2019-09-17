class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

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
    render "show"
    return
    if @page != nil
      render "show"
    else
      parent = get_parent_path path
      parent = Page.find_by(path:parent)
      #if parent is not found, render 404 
      #render createnewpage
      @page = Page.new
      render "edit"
    end
  end

  def file_show
    path = params[:pages]
    #filename以外のpathを取得
    path = get_parent_path path
    title = get_title path
    page = Page.where()
  end
  # GET /pages/1
  # GET /pages/1.json
  def show
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json

  def create_route
    if params[:pages] != nil
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
    if parent != nil || path == ""
      page = Page.new(
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
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json

  #updateはpageのみ
  def update

    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
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
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
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
      path_ = path.split("/")
      title = path_[path_.size - 1]
      return title
    end

    def is_editable? page
      return true
    end
    def is_readable? page
      return true
    end
end
