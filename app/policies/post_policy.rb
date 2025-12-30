class PostPolicy < ApplicationPolicy
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
