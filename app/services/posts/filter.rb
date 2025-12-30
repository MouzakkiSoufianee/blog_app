# frozen_string_literal: true

module Posts
  class Filter < ApplicationService
    def initialize(params:, scope: Post.all, current_user: nil)
      @params = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params.to_h
      @scope = scope
      @current_user = current_user
    end

    def call
      filtered.recent
    end

    private

    attr_reader :params, :scope, :current_user

    def filtered
      scoped = scope.includes(:user)
      scoped = scoped.by_author(params[:author_id])
      scoped = scoped.search(params[:query])

      if current_user&.admin?
        case params[:status]
        when "published"
          scoped.published_posts
        when "drafts"
          scoped.drafts
        else
          scoped
        end
      elsif current_user.present?
        scoped.published_posts.or(scoped.where(user_id: current_user.id).drafts)
      else
        scoped.published_posts
      end
    end
  end
end
