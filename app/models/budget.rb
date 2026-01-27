class Budget < ApplicationRecord
  validates :title, :category, :color, :max, presence: true
  validates :max, numericality: { greater_than: 0 }

  validates :category, uniqueness: {
    case_sensitive: false,
    message: "budget already exists for this category"
  }

  validates :color, uniqueness: {
    case_sensitive: false,
    message: "color already used"
  }

  after_initialize do
    self.spent ||= 0
  end

  def remaining
    max - spent
  end
end
