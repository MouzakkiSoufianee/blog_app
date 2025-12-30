class CommentPolicy < ApplicationPolicy
  def edit?
    owner? || admin?
  end

  def update?
    edit?
  end

  def destroy?
    owner? || admin?
  end

  private

  def owner?
    record.user_id == user&.id
  end

  def admin?
    user&.admin?
  end
end
