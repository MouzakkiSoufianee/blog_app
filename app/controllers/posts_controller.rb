class PostsController < ApplicationController
  include ActionPolicy::Controller

  before_action :set_post, only: %i[show edit update destroy publish unpublish]

  def index
    @posts = Posts::Filter.call(params: params, current_user: current_user)
    @users = User.order(:name)
  end

  def show
    authorize! @post, to: :show? if user_signed_in? || !@post.published?
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    result = Posts::Create.call(user: current_user, params: post_params, publish_now: publish_now_param?)
    @post = result.post

    if result.success?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Post created successfully." }
      end
    else
      flash.now[:alert] = result.error || "Please fix the errors below"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # WHY: Check if current user is allowed to edit this post
    # Only owner or admin can edit
    authorize! @post, to: :edit?
  end

  def update
    # WHY: Check authorization before updating
    authorize! @post, to: :update?

    if @post.update(post_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Post updated successfully." }
      end
    else
      flash.now[:alert] = "Please fix the errors below"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # WHY: Only admin can delete
    authorize! @post, to: :destroy?

    @post.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path, notice: "Post deleted successfully." }
    end
  end

  def publish
    # WHY: Check if user is allowed to publish this post
    authorize! @post, to: :publish?

    result = Posts::Publish.call(post: @post, user: current_user)
    handle_publish_response(result, notice: "Post published.")
  end

  def unpublish
    # WHY: Check if user is allowed to unpublish this post
    authorize! @post, to: :unpublish?

    result = Posts::Unpublish.call(post: @post, user: current_user)
    handle_publish_response(result, notice: "Post moved back to draft.")
  end

  private

  def set_post
    @post = Post.includes(:user, comments: :user).find_by!(slug: params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :status, :published_at)
  end

  def publish_now_param?
    post_params[:status].to_s == "published"
  end

  def handle_publish_response(result, notice:)
    @post = result.post

    respond_to do |format|
      if result.success?
        format.turbo_stream
        format.html { redirect_to @post, notice: notice }
      else
        flash.now[:alert] = result.error || "Unable to update publication state."
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(dom_id(@post, :status), partial: "posts/status_badge", locals: { post: @post }),
            turbo_stream.replace(dom_id(@post, :status_show), partial: "posts/status_badge", locals: { post: @post, id_suffix: :status_show, show_timestamp: true })
          ], status: :unprocessable_entity
        end
        format.html { redirect_to @post, alert: result.error || "Unable to update publication state." }
      end
    end
  end
end
