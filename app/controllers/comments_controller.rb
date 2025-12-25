class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added successfully." }
      end
    else
      @users = User.order(:name)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def edit
    @users = User.order(:name)
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment updated successfully." }
      end
    else
      @users = User.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "Comment deleted successfully." }
    end
  end

  private

  def set_post
    @post = Post.includes(:user, comments: :user).find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end
end
