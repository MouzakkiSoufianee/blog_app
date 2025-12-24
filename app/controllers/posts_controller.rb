class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_users, only: %i[new create edit update show]

  def index
    @posts = Post.includes(:user)

    # Apply filters based on params
    @posts = @posts.by_author(params[:author_id])
    @posts = @posts.search(params[:query])

    case params[:status]
    when "published"
      @posts = @posts.published_posts
    when "drafts"
      @posts = @posts.drafts
    end

    @posts = @posts.recent
    @users = User.order(:name)
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post updated successfully."
    else
      flash.now[:alert] = "Please fix the errors below"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Post deleted successfully."
  end

  private

  def set_post
    @post = Post.includes(:user, comments: :user).find(params[:id])
  end

  def set_users
    @users = User.order(:name)
  end

  def post_params
    params.require(:post).permit(:title, :body, :status, :published_at, :user_id)
  end
end
