require "rails_helper"
RSpec.describe RecurringBill, type: :model do
  let(:user) { User.create!(name: "sheik", email: "demo@gmail.", password: "password123") }
  let(:account) { user.accounts.create!(name: "Bank", balance: 2000) }

  it "rejects past next_run_on" do
    bill = RecurringBill.new(
      user: user,
      account: account,
      name: "Internet",
      amount: 500,
      frequency: "monthly",
      next_run_on: Date.yesterday
    )
    expect(bill).not_to be_valid
  end

  it "calculates next run date" do
    bill = RecurringBill.new(frequency: "monthly", next_run_on: Date.today)
    expect(bill.next_run_date).to eq(Date.today + 1.month)
  end
end
