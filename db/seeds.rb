# Add seed data here when needed. Keep it idempotent.

# Clear existing records
User.destroy_all
Post.destroy_all

# Create test users
admin = User.create!(
  email: "admin@example.com",
  name: "Admin User",
  password: "password123",
  password_confirmation: "password123",
  role: "admin"
)

regular = User.create!(
  email: "user@example.com",
  name: "Regular User",
  password: "password123",
  password_confirmation: "password123",
  role: "member"
)

# Create test posts
Post.create!(
  title: "Published Admin Post",
  body: "This is a published post by the admin.",
  status: :published,
  user: admin,
  slug: "published-admin-post"
)

Post.create!(
  title: "Draft Admin Post",
  body: "This is a draft post by the admin.",
  status: :draft,
  user: admin,
  slug: "draft-admin-post"
)

Post.create!(
  title: "Published User Post",
  body: "This is a published post by the regular user.",
  status: :published,
  user: regular,
  slug: "published-user-post"
)

Post.create!(
  title: "Draft User Post",
  body: "This is a draft post by the regular user.",
  status: :draft,
  user: regular,
  slug: "draft-user-post"
)

puts "✓ Created 2 users: admin@example.com and user@example.com (password: password123)"
puts "✓ Created 4 posts (2 published, 2 drafts)"
