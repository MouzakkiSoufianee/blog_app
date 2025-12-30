# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.1]
  def self.up
    ## Database authenticatable
    add_column :users, :encrypted_password, :string, null: false, default: "" unless column_exists?(:users, :encrypted_password)

    ## Recoverable
    add_column :users, :reset_password_token, :string unless column_exists?(:users, :reset_password_token)
    add_column :users, :reset_password_sent_at, :datetime unless column_exists?(:users, :reset_password_sent_at)

    ## Rememberable
    add_column :users, :remember_created_at, :datetime unless column_exists?(:users, :remember_created_at)

    ## Trackable (optional)
    # add_column :users, :sign_in_count, :integer, default: 0, null: false unless column_exists?(:users, :sign_in_count)
    # add_column :users, :current_sign_in_at, :datetime unless column_exists?(:users, :current_sign_in_at)
    # add_column :users, :last_sign_in_at, :datetime unless column_exists?(:users, :last_sign_in_at)
    # add_column :users, :current_sign_in_ip, :string unless column_exists?(:users, :current_sign_in_ip)
    # add_column :users, :last_sign_in_ip, :string unless column_exists?(:users, :last_sign_in_ip)

    ## Confirmable (optional)
    # add_column :users, :confirmation_token, :string unless column_exists?(:users, :confirmation_token)
    # add_column :users, :confirmed_at, :datetime unless column_exists?(:users, :confirmed_at)
    # add_column :users, :confirmation_sent_at, :datetime unless column_exists?(:users, :confirmation_sent_at)
    # add_column :users, :unconfirmed_email, :string unless column_exists?(:users, :unconfirmed_email)

    ## Lockable (optional)
    # add_column :users, :failed_attempts, :integer, default: 0, null: false unless column_exists?(:users, :failed_attempts)
    # add_column :users, :unlock_token, :string unless column_exists?(:users, :unlock_token)
    # add_column :users, :locked_at, :datetime unless column_exists?(:users, :locked_at)

    add_index :users, :reset_password_token, unique: true unless index_exists?(:users, :reset_password_token)
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
