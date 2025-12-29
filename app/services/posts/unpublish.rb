# frozen_string_literal: true

module Posts
  class Unpublish < ApplicationService
    def initialize(post:, user:)
      @post = post
      @user = user
    end

    def call
      return unauthorized_result unless authorized?

      post.status = :draft if post.respond_to?(:status=)
      post.published_at = nil

      if post.save
        Result.success(payload: { post: post })
      else
        Result.failure(error: human_errors_for(post), code: :invalid, payload: { post: post })
      end
    end

    private

    attr_reader :post, :user

    def authorized?
      user.present?
    end

    def unauthorized_result
      Result.failure(error: "You are not authorized to unpublish this post.", code: :forbidden, payload: { post: post })
    end

    def human_errors_for(record)
      record.errors.full_messages.to_sentence.presence || "Unable to unpublish"
    end
  end
end
