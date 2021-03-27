class CommentsController < ApplicationController
  include PathHelper

  def create
    pathname = get_formal_pathname params[:pages]
    path = pathname.to_s
    page = Page.find_by_pathname(pathname)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    authorize! :read, page

    comment_param = params.require(:comment).permit(:content)
    comment = Comment.new(
      user: current_user,
      page: page,
      comment: comment_param[:content],
    )
    respond_to do |format|
      if comment.save
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
    page = Page.find_by_pathname(pathname)

    if page == nil
      raise ActiveRecord::RecordNotFound
    end

    comment_param = params.require(:comment).permit(:comment_id)
    comment = page.comments.find(comment_param[:comment_id])

    if cannot?(:write, page) && cannot?(:write, comment)
      # not permittedを返した方が…？
      raise ActiveRecord::RecordNotFound
    end

    comment.destroy
    respond_to do |format|
      format.html { redirect_to path, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
