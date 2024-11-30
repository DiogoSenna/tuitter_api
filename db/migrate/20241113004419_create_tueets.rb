class CreateTueets < ActiveRecord::Migration[7.1]
  def change
    create_table :tueets do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :tueets }

      t.timestamps
    end
  end
end
