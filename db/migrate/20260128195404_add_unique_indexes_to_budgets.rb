class AddUniqueIndexesToBudgets < ActiveRecord::Migration[8.1]
  def change
    add_index :budgets,
      "LOWER(category), user_id",
      unique: true,
      name: "index_budgets_on_category_and_user"

    add_index :budgets,
      "LOWER(color), user_id",
      unique: true,
      name: "index_budgets_on_color_and_user"
  end
end
