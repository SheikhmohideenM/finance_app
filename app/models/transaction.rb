class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :account
  belongs_to :budget, optional: true
  belongs_to :recurring_bill, optional: true

  has_one :category, through: :budget

  validates :amount, presence: true
  validates :date, presence: true

  validate :budget_limit_check, on: :create

  def editable?
    Time.current <= created_at + 24.hours
  end

  private

  def budget_only_for_expenses
    if budget.present? && amount.positive?
      errors.add(:budget, "can only be assigned to expenses")
    end
  end

  def budget_limit_check
    return unless budget.present? && amount.negative?

    if budget.remaining < amount.abs
      errors.add(:amount, "exceeds remaining budget")
    end
  end
end
