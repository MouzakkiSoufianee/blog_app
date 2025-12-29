require "test_helper"

class Posts::CreateTest < ActiveSupport::TestCase
  test "creates post for user with slug" do
    user = users(:one)
    params = { title: "Hello World", body: "Test content", status: "draft" }

    result = Posts::Create.call(user: user, params: params)

    assert result.success?
    assert_equal "Hello World", result.post.title
    assert_equal "hello-world", result.post.slug
    assert_equal "draft", result.post.status
    assert_nil result.post.published_at
  end

  test "publishes immediately when publish_now is true" do
    user = users(:one)
    params = { title: "Quick Publish", body: "Content", status: "published" }

    result = Posts::Create.call(user: user, params: params, publish_now: true)

    assert result.success?
    assert_equal "published", result.post.status
    assert_not_nil result.post.published_at
  end

  test "returns failure with validation errors" do
    user = users(:one)
    params = { title: "", body: "" }

    result = Posts::Create.call(user: user, params: params)

    assert result.failure?
    assert_equal :invalid, result.code
    assert_includes result.error, "can't be blank"
  end
end
