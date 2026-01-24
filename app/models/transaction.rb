class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :category

  validates :amount, :date, presence: true

  after_save :update_account_balance
  after_destroy :update_account_balance

  def update_account_balance
    account.update(balance: account.transactions.sum(:amount))
  end
end
