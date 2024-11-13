class RolesPolicy < ApplicationPolicy
  def index?
    user.can?(:roles_index)
  end

  def show?
    user.can?(:roles_show)
  end

  def create?
    user.can?(:roles_create)
  end

  def update?
    user.can?(:roles_update)
  end

  def destroy?
    user.can?(:roles_delete)
  end
end