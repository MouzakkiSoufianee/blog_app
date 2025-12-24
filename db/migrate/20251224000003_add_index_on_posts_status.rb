class AddIndexOnPostsStatus < ActiveRecord::Migration[8.1]
  def change
    add_index :posts, :status
  end
end
