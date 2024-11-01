# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, User do |user|
      ! user.profile&.is_private
    end

    return unless user.present?
    can :read, :all

    return unless user.admin?
    can :manage, :all
  end
end
