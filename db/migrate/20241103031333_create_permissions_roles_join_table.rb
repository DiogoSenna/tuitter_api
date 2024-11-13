class CreatePermissionsRolesJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :permissions, :roles do |t|
      t.index %i[permission_id role_id], unique: true

      t.foreign_key :permissions
      t.foreign_key :roles
    end
  end
end
