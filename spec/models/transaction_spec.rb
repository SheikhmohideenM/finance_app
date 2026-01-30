require "rails_helper"
RSpec.describe Transaction, type: :model do
  let(:user) { User.create!(name: "sheik", email: "demo@gmail.", password: "password123") }
  let(:account) { user.accounts.create!(name: "Cash", balance: 1000) }
  let(:budget) { user.budgets.create!(title: "Food", category: "Food", color: "red", max: 500, spent: 450) }

  it "rejects expense exceeding budget" do
    tx = Transaction.new(
      user: user,
      account: account,
      budget: budget,
      amount: -100,
      date: Date.today
    )
    expect(tx).not_to be_valid
  end

  it "allows editing within 24 hours" do
    tx = Transaction.create!(
      user: user,
      account: account,
      amount: -50,
      date: Date.today
    )
    expect(tx.editable?).to be true
  end
end
