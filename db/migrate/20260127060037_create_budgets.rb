class CreateBudgets < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets do |t|
      t.string :title
      t.string :category
      t.decimal :max
      t.decimal :spent
      t.string :color

      t.timestamps
    end
  end
end
