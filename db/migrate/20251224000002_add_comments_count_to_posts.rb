class AddCommentsCountToPosts < ActiveRecord::Migration[8.1]
  def change
    add_column :posts, :comments_count, :integer, default: 0, null: false

    # Backfill existing posts
    Post.all.each do |post|
      post.update_column(:comments_count, post.comments.count)
    end
  end
end
