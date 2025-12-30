class ApplicationPolicy < ActionPolicy::Base
  authorize :user, optional: true

  scope_matcher :active_record_relation, ActiveRecord::Relation
  scope_matcher :active_record_relation, ->(target) { target.is_a?(Class) && target < ActiveRecord::Base }

  private

  def owner?
    return false if user.nil?
    record.user_id == user.id
  end

  def admin?
    user&.admin?
  end
end
