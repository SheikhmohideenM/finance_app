class Budget < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :recurring_bills

  validates :title, :category, :color, :max, presence: true
  validates :max, numericality: { greater_than: 0 }

  validates :category, uniqueness: {
    scope: :user_id,
    case_sensitive: false,
    message: "budget already exists for this category"
  }

  validates :color, uniqueness: {
    scope: :user_id,
    case_sensitive: false,
    message: "color already used"
  }

  after_initialize do
    self.spent ||= 0
  end

  def spent
    transactions
      .where("date <= ?", Date.today)
      .sum(:amount)
      .abs
  end

  def remaining
    max - spent
  end
end
