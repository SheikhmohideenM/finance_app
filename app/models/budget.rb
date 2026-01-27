class Budget < ApplicationRecord
  validates :title, :category, :color, :max, presence: true
  validates :max, numericality: { greater_than: 0 }

  after_initialize do
    self.spent ||= 0
  end

  def remaining
    max - spent
  end
end
