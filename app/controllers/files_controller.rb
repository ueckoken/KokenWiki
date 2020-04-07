class FilesController < ApplicationController
  include PathHelper
  before_action :authenticate_user!, only: [:create, :destroy]

  def show
    pathname = get_formal_pathname params[:pages]
    parentPathname = pathname.parent
    # filename以外のpathを取得
    filename = pathname.basename.to_s + "." + params[:format]
    page = Page.find_by(path: parentPathname.to_s)
    if page == nil || !page.is_readable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    file = page.files.joins(:blob).find_by(active_storage_blobs: { filename: filename })
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

  def create
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by(path: path)
    if page == nil || !page.is_readable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    file_param = params.require(:file).permit(files: [])
    success_flag = true
    if page.is_editable_user?(current_user)
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
    else
      success_flag = false
    end
    respond_to do |format|
      if success_flag
        format.html { redirect_to path, notice: 'Files were successfully uploaded.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { redirect_to path, alert: 'Files were not updated, something wrong' }
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    pathname = get_formal_pathname params[:pages]
    # filename以外のpathを取得
    filename = pathname.basename.to_s + "." + params[:format]
    parent_pathname = pathname.parent
    page = Page.find_by(path: parent_pathname.to_s)
    if page == nil || !page.is_editable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    file = page.files.joins(:blob).find_by(active_storage_blobs: { filename: filename })
    if file == nil
      raise ActiveRecord::RecordNotFound
    else
      file.purge
    end

    redirect_to parent_pathname.to_s, notice: 'File was successfully destroyed.'
  end

  def is_valid_uri? filename
    begin
      URI.parse(URI.escape filename)
    rescue URI::InvalidURIError
      return false
    end
    return true
  end
end
