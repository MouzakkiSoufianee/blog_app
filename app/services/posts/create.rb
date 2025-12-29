# frozen_string_literal: true

module Posts
  class Create < ApplicationService
    def initialize(user:, params:, publish_now: false)
      @user = user
      @params = params
      @publish_now = publish_now
    end

    def call
      return Result.failure(error: "You need to sign in first.", code: :unauthorized, payload: { post: Post.new(filtered_params) }) if user.nil?

      post = build_post
      publish_now(post) if publish_now?

      if post.save
        Result.success(payload: { post: post })
      else
        Result.failure(error: human_errors_for(post), code: :invalid, payload: { post: post })
      end
    end

    private

    attr_reader :user, :params, :publish_now

    def build_post
      user.posts.build(filtered_params)
    end

    def filtered_params
      params.except(:user_id)
    end

    def publish_now(post)
      post.status = :published if post.respond_to?(:status)
      post.published_at ||= Time.current
    end

    def publish_now?
      ActiveModel::Type::Boolean.new.cast(@publish_now)
    end

    def human_errors_for(record)
      record.errors.full_messages.to_sentence.presence || "Unable to save record"
    end
  end
end
