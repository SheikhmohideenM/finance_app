class Pot < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 30 }
  validates :color, presence: true
  validates :target, numericality: { greater_than: 0 }
  validates :saved, numericality: { greater_than_or_equal_to: 0 }

  def percent
    return 0 if target.zero?
    ((saved / target) * 100).round(2)
  end
end
