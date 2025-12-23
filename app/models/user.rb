class User < ApplicationRecord
  has_many :posts, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true
end
