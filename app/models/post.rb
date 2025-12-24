class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy

  enum :status, { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true

  # Scopes
  scope :published_posts, -> { where(status: statuses[:published]) }
  scope :drafts, -> { where(status: statuses[:draft]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_author, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :search, ->(query) {
    return all if query.blank?
    where("title LIKE ? OR body LIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")
  }
end
