class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: :destroy

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      redirect_to @post, notice: "Comment added successfully."
    else
      @users = User.order(:name)
      render "posts/show", status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    redirect_to @post, notice: "Comment deleted successfully."
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
