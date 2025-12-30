module Posts
  module Filterable
    def apply_filters(scope)
      filtered = scope
      filtered = filtered.by_author(params[:author_id]) if params[:author_id].present?
      filtered = filtered.search(params[:query]) if params[:query].present?

      # WHY: Only admins can filter by status (drafts vs published)
      # WHAT: Regular users already have proper scoping via the policy
      if current_user&.admin? && params[:status].present?
        case params[:status]
        when "published"
          filtered = filtered.published_posts
        when "drafts"
          filtered = filtered.drafts
        end
      end

      filtered
    end
  end
end
