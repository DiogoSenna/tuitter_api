# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, User

    return unless user.present?
    can :read, User
    can %i[update destroy], User, id: user.id
    can :show, Profile, is_private: false
    can :manage, Profile, user_id: user.id

    return unless user.admin?
    can :manage, :all
  end
end
