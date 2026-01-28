class FixBudgetUniqueIndexes < ActiveRecord::Migration[8.1]
  def change
    remove_index :budgets, name: "index_budgets_on_color", if_exists: true
    remove_index :budgets, name: "index_budgets_on_category", if_exists: true

    add_index :budgets,
      "LOWER(category), user_id",
      unique: true,
      name: "index_budgets_on_category_and_user",
      if_not_exists: true

    add_index :budgets,
      "LOWER(color), user_id",
      unique: true,
      name: "index_budgets_on_color_and_user",
      if_not_exists: true
  end
end
