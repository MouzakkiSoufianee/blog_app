class ApplicationPolicy < ActionPolicy::Base
  private

  def owner?
    return false if user.nil?
    record.user_id == user.id
  end

  def admin?
    user&.admin?
  end
end
