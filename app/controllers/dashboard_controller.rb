class DashboardController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @accounts = current_user.accounts
    @transactions = Transaction.joins(account: :user).where(accounts: { user_id: current_user.id })
    @monthly_spend = @transactions
                    .where(date: Date.current.beginning_of_month..Date.current.end_of_month)
                    .group(:category_id)
                    .sum(:amount)
  end
end
