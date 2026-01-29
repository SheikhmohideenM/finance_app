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

  # def spent(as_of: Date.current)
  #   transactions
  #     .where(undone: [ false, nil ])
  #     .where("date <= ?", as_of)
  #     .where("amount < 0")
  #     .sum("ABS(amount)")
  # end

  after_initialize do
    self.spent ||= 0
  end

  def remaining
    max - spent
  end
end
