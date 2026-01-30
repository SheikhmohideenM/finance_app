class ReplaceCategoryWithBudgetInTransactions < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :budget, foreign_key: true, null: true
    remove_reference :transactions, :category, foreign_key: true
  end
end
