class AddUndoneToTransactions < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :undone, :boolean
  end
end
