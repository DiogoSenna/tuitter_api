class Role < ApplicationRecord
  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions

  def has_permission?(permission)
    permissions.include?(permission)
  end
end
