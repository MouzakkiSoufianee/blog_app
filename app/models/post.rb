class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, -> { order(created_at: :desc) }, dependent: :destroy
  has_one_attached :cover_image

  enum :status, { draft: 0, published: 1 }

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :cover_image_validation

  before_validation :generate_slug, on: :create
  before_validation :ensure_unique_slug, on: :create

  # Scopes
  scope :published_posts, -> { where(status: statuses[:published]) }
  scope :drafts, -> { where(status: statuses[:draft]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_author, ->(user_id) { where(user_id: user_id) if user_id.present? }
  scope :search, ->(query) {
    return all if query.blank?
    where("title LIKE ? OR body LIKE ?", "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%")
  }

  def to_param
    slug
  end

  private

  def generate_slug
    return unless respond_to?(:slug=)
    return if self[:slug].present?
    self.slug = title.to_s.parameterize if title.present?
  end

  def ensure_unique_slug
    return unless respond_to?(:slug)
    return if self[:slug].blank?

    base_slug = self[:slug]
    counter = 2

    while Post.where(slug: self[:slug]).where.not(id: id).exists?
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end

  def cover_image_validation
    if cover_image.attached?
      # Validate content type
      unless cover_image.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:cover_image, "must be jpeg, png, or webp")
      end

      # Validate size
      if cover_image.blob.byte_size > 5.megabytes
        errors.add(:cover_image, "must be less than 5MB")
      end
    end
  end
end
