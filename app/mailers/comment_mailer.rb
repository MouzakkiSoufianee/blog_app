class CommentMailer < ApplicationMailer
  default from: "noreply@blog.local"

  def new_comment(comment)
    @comment = comment
    @post = comment.post
    @commenter = comment.user

    # Email post author
    mail(to: @post.user.email, subject: "New comment on '#{@post.title}'")
  end
end
