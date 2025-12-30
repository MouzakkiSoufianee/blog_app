# frozen_string_literal: true

module Comments
  class Create < ApplicationService
    SPAM_KEYWORDS = %w[casino free-money loan offer viagra clickbait].freeze

    def initialize(user:, post:, params:)
      @user = user
      @post = post
      @params = params
    end

    def call
      return unauthorized_result unless user.present?

      comment = build_comment
      return spam_result(comment) if spam?(comment.body)

      if comment.valid?
        Comment.transaction do
          comment.save!
          CommentMailer.new_comment(comment).deliver_later
        end
        Result.success(payload: { comment: comment, post: post })
      else
        Result.failure(error: human_errors_for(comment), code: :invalid, payload: { comment: comment, post: post })
      end
    rescue ActiveRecord::RecordInvalid
      Result.failure(error: human_errors_for(comment), code: :invalid, payload: { comment: comment, post: post })
    end

    private

    attr_reader :user, :post, :params

    def build_comment
      attributes = filtered_params
      attributes[:body] = attributes[:body].to_s.strip
      post.comments.build(attributes.merge(user: user))
    end

    def filtered_params
      params.slice(:body)
    end

    def spam?(body)
      text = body.to_s.downcase
      SPAM_KEYWORDS.any? { |keyword| text.include?(keyword) }
    end

    def spam_result(comment)
      comment.errors.add(:base, "Your comment looks like spam.")
      Result.failure(error: "We could not post that comment.", code: :spam_blocked, payload: { comment: comment, post: post })
    end

    def unauthorized_result
      Result.failure(error: "You need to sign in to comment.", code: :unauthorized, payload: { comment: post.comments.build, post: post })
    end

    def human_errors_for(record)
      record.errors.full_messages.to_sentence.presence || "Unable to save comment"
    end
  end
end
