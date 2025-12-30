class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def create
    result = Comments::Create.call(user: current_user, post: @post, params: comment_params)
    @comment = result.comment

    if result.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment added successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_comment_form",
            partial: "comments/form_with_error",
            locals: { post: @post, comment: @comment, error_message: friendly_comment_error(result) }
          ), status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = friendly_comment_error(result)
          render "posts/show", status: :unprocessable_entity
        end
      end
    end
  end

  def edit
  end

  def update
    authorize! @comment, to: :update?

    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment updated successfully." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @comment, to: :destroy?

    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @post, notice: "Comment deleted successfully." }
    end
  end

  private

  def set_post
    @post = Post.includes(:user, comments: :user).find_by!(slug: params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def friendly_comment_error(result)
    return "Please sign in to comment." if result.code == :unauthorized
    return "We blocked that comment because it looks like spam." if result.code == :spam_blocked

    result.error || "Please fix the errors below"
  end
end
