class CreatePermissionsUsersJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_join_table :permissions, :users do |t|
      t.index %i[permission_id user_id], unique: true

      t.foreign_key :permissions
      t.foreign_key :users
    end
  end
end
