class UsersPolicy < ApplicationPolicy
  def update?
    user.can?(:users_update) || record.id === user.id
  end

  def destroy?
    user.can?(:users_delete) || record.id === user.id
  end
end