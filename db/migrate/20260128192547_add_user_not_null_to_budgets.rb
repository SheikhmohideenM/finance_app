class AddUserNotNullToBudgets < ActiveRecord::Migration[8.1]
  def change
    change_column_null :budgets, :user_id, false
  end
end
