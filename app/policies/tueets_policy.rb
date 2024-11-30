class TueetsPolicy < ApplicationPolicy
  def update?
    user.admin? || user.can?(:tueets_update) && record.user == user
  end

  def destroy?
    user.admin? || record.user == user
  end
end