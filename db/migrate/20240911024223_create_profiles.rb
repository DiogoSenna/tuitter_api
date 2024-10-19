class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.date :birth_date, null: false
      t.string :country, null: false
      t.string :state, null: false
      t.string :city, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
