class AddUniqueIndexToBudgetsColor < ActiveRecord::Migration[8.1]
  def change
    add_index :budgets, :color, unique: true
  end
end
