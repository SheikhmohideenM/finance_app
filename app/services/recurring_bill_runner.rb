# app/services/recurring_bill_runner.rb
class RecurringBillRunner
  def self.run!
    RecurringBill
      .where(auto_pay: true)
      .where("next_run_on <= ?", Date.today)
      .find_each do |bill|
        if bill.budget && bill.budget.remaining < bill.amount
          Rails.logger.info "Skipping bill #{bill.id} – budget exhausted"
          next
        end

        ActiveRecord::Base.transaction do
          Transaction.create!(
            user: bill.user,
            account: bill.account,
            budget: bill.budget,
            recurring_bill: bill,
            amount: -bill.amount, # 👈 EXPENSE
            date: bill.next_run_on,
            description: "Auto-pay: #{bill.name}"
          )

          bill.account.update!(
            balance: bill.account.balance - bill.amount
          )

          bill.update!(next_run_on: bill.next_run_date)
        end
      end
  end
end
