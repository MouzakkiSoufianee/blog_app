class PostPolicy < ApplicationPolicy
  relation_scope do |relation|
    case user
    when nil
      relation.published_posts
    when ->(u) { u.admin? }
      relation.all
    else
      relation.published_posts.or(relation.where(user_id: user.id).drafts)
    end
  end

  def show?
    record.published? || owner? || admin?
  end

  def new?
    user.present?
  end

  def create?
    new?
  end

  def edit?
    owner? || admin?
  end

  def update?
    edit?
  end

  def destroy?
    admin?
  end

  def publish?
    owner? || admin?
  end

  def unpublish?
    publish?
  end
end
