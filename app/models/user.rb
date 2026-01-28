class User < ApplicationRecord
  has_secure_password

  has_many :accounts, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :pots, dependent: :destroy
  has_many :recurring_bills, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: {
    with: URI::MailTo::EMAIL_REGEXP,
    message: "is not valid email"
  }
  validates :password, length: { minimum: 5, maximum: 12 }, if: -> { password.present? }
end
