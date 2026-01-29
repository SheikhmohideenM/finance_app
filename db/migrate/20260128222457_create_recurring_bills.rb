class CreateRecurringBills < ActiveRecord::Migration[8.1]
  def change
    create_table :recurring_bills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.references :budget, foreign_key: true

      t.string :name, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :frequency, null: false
      t.date :next_run_on, null: false
      t.boolean :auto_pay, default: true

      t.timestamps
    end
  end
end
