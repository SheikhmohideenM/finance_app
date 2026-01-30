class RecurringBill < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :budget, optional: true

  FREQUENCIES = %w[weekly monthly yearly].freeze

  validates :name, :amount, :frequency, :next_run_on, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :frequency, inclusion: { in: FREQUENCIES }

  validate :next_run_on_cannot_be_past

  validate :budget_has_enough_remaining, if: -> { budget.present? }

  # Detect when recurring bill created
  # after_create :create_initial_transaction, if: -> { auto_pay && budget.present? }

  def budget_has_enough_remaining
    if budget.remaining < amount
      errors.add(:amount, "exceeds remaining budget")
    end
  end

  def next_run_on_cannot_be_past
    if next_run_on.present? && next_run_on < Date.today
      errors.add(:next_run_on, "cannot be in the past")
    end
  end

  # Detect when recurring bill created
  # def create_initial_transaction
  #   Transaction.create!(
  #     user: user,
  #     account: account,
  #     budget: budget,
  #     amount: amount,
  #     date: next_run_on,
  #     description: "Auto-pay: #{name}"
  #   )
  # end

  def next_run_date
    case frequency
    when "weekly"  then next_run_on + 1.week
    when "monthly" then next_run_on + 1.month
    when "yearly"  then next_run_on + 1.year
    end
  end
end
