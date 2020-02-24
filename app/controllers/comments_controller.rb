class CommentsController < ApplicationController
  include PathHelper
  before_action :authenticate_user!

  def create
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by(path: path)
    if page == nil || !page.is_readable_user?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    comment_param = params.require(:comment).permit(:content)
    success_flag = true
    if page.is_readable_user?(current_user)
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
        format.html { redirect_to path, notice: 'Comment was successfully createed.' }
        format.json { render :show, status: :ok, location: path }
      else
        format.html { render :show, alert: 'Comment was not created, something wrong' }
        format.json { render json: page.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by(path: path)
    if page == nil
      raise ActiveRecord::RecordNotFound
    end
    comment_param = params.require(:comment).permit(:comment_id)
    comment = page.comments.find(comment_param[:comment_id])
    if page.is_editable_user?(current_user) || comment.user == current_user
      comment.destroy
    else
      # not permittedを返した方が…？
      raise ActiveRecord::RecordNotFound
    end
    respond_to do |format|
      format.html { redirect_to path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
