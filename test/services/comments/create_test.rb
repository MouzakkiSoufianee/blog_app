require "test_helper"

class Comments::CreateTest < ActiveSupport::TestCase
  test "creates valid comment" do
    user = users(:one)
    post = posts(:one)
    params = { body: "Great post!" }

    result = Comments::Create.call(user: user, post: post, params: params)

    assert result.success?
    assert_equal "Great post!", result.comment.body
  end

  test "blocks spam comments" do
    user = users(:one)
    post = posts(:one)
    params = { body: "Check out this casino free-money offer!" }

    result = Comments::Create.call(user: user, post: post, params: params)

    assert result.failure?
    assert_equal :spam_blocked, result.code
    assert_includes result.error, "could not post"
  end

  test "rejects empty body" do
    user = users(:one)
    post = posts(:one)
    params = { body: "   " }

    result = Comments::Create.call(user: user, post: post, params: params)

    assert result.failure?
    assert_equal :invalid, result.code
  end
end
