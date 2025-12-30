class User < ApplicationRecord
  # Devise authentication: keep minimal modules per exercise
  devise :database_authenticatable, :registerable
  has_many :posts, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true

  def admin?
    role.to_s == "admin"
  end
end
