class AddUniqueIndexToBudgetsCategory < ActiveRecord::Migration[8.1]
  def change
    add_index :budgets, :category, unique: true
  end
end
