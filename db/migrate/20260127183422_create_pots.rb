class CreatePots < ActiveRecord::Migration[8.1]
  def change
    create_table :pots do |t|
      t.string :name, null: false
      t.string :color, null: false
      t.decimal :target, precision: 12, scale: 2, null: false
      t.decimal :saved, precision: 12, scale: 2, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
