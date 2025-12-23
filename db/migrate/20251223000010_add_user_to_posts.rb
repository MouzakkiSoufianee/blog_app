class AddUserToPosts < ActiveRecord::Migration[7.1]
  def up
    add_reference :posts, :user, null: true, foreign_key: { on_delete: :restrict }, index: true

    say_with_time "Backfilling posts.user_id" do
      user = User.create!(name: "Imported", email: "imported@example.com")
      User.reset_column_information
      Post.reset_column_information
      Post.where(user_id: nil).update_all(user_id: user.id)
    end

    change_column_null :posts, :user_id, false
  end

  def down
    remove_reference :posts, :user, index: true, foreign_key: true
  end
end
