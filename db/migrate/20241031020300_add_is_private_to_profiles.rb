class AddIsPrivateToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :is_private, :boolean, default: false, null: false
  end
end
