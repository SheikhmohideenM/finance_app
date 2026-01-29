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
          if Transaction.exists?(
            account_id: bill.account_id,
            date: Date.today,
            description: "Auto-pay: #{bill.name}"
          )
            next
          end

          Transaction.create!(
            user: bill.user,
            account: bill.account,
            budget: bill.budget,
            amount: -bill.amount,
            date: Date.today,
            description: "Auto-pay: #{bill.name}"
          )

          bill.account.update!(
            balance: bill.account.balance - bill.amount
          )

          if bill.budget
            bill.budget.update!(
              spent: bill.budget.spent + bill.amount
            )
          end

          bill.update!(
            next_run_on: bill.next_run_date
          )
        end
      end
  end
end
