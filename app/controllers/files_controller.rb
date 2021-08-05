class FilesController < ApplicationController
  include PathHelper

  def show
    pathname = get_formal_pathname params[:pages]
    # filename以外のpathを取得
    filename = pathname.basename.to_s + "." + params[:format]
    page = Page.find_by_pathname(pathname.parent)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :read, page

    file = page.files.joins(:blob).find_by(active_storage_blobs: { filename: filename })
    if file == nil
      raise ActiveRecord::RecordNotFound
    end

    # rails_storage_redirect_path と同じ
    # 最終的に短時間だけパブリックアクセス可能なURLにリダイレクトされる
    redirect_to file
  end

  def create
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by_pathname(pathname)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :write, page

    file_param = params.require(:file).permit(files: [])
    success_flag = true
    file_param["files"].each do |file|
      filename = file.original_filename.to_s

      prev_file = page.files.joins(:blob).find_by(active_storage_blobs: { filename: filename })
      if prev_file != nil
        prev_file.purge
      end

      if /\A^[^?#]*\.[^?#]*$\Z/.match?(filename) && is_valid_uri?(filename)
        page.files.attach file
      else
        success_flag = false
      end
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path, notice: "Files were successfully uploaded." }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { redirect_to path, alert: "Files were not updated, something wrong" }
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    pathname = get_formal_pathname params[:pages]
    # filename以外のpathを取得
    filename = pathname.basename.to_s + "." + params[:format]
    page_pathname = pathname.parent
    page = Page.find_by_pathname(page_pathname)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :write, page

    file = page.files.joins(:blob).find_by(active_storage_blobs: { filename: filename })
    if file == nil
      raise ActiveRecord::RecordNotFound
    else
      file.purge
    end

    redirect_to page_pathname.to_s, notice: "File was successfully destroyed."
  end

  def is_valid_uri?(filename)
    begin
      parsable_filename = ERB::Util.url_encode filename
      URI.parse(parsable_filename)
    rescue URI::InvalidURIError
      return false
    end
    return true
  end
end
