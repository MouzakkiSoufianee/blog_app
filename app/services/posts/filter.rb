# frozen_string_literal: true

module Posts
  class Filter < ApplicationService
    def initialize(params:, scope: Post.all)
      @params = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params.to_h
      @scope = scope
    end

    def call
      filtered.recent
    end

    private

    attr_reader :params, :scope

    def filtered
      scoped = scope.includes(:user)
      scoped = scoped.by_author(params[:author_id])
      scoped = scoped.search(params[:query])

      case params[:status]
      when "published"
        scoped.published_posts
      when "drafts"
        scoped.drafts
      else
        scoped
      end
    end
  end
end
