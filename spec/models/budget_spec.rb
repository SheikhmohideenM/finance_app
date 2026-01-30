require "rails_helper"

RSpec.describe Budget, type: :model do
  let(:user) { User.create!(name: "sheik", email: "demo@gmail.", password: "password123") }

  it "calculates remaining correctly" do
    budget = user.budgets.create!(
      title: "Food",
      category: "Food",
      color: "red",
      max: 500,
      spent: 200
    )
    expect(budget.remaining).to eq(300)
  end

  it "prevents duplicate category per user" do
    user.budgets.create!(title: "Food", category: "Food", color: "red", max: 500)
    duplicate = user.budgets.new(title: "Food2", category: "Food", color: "blue", max: 300)
    expect(duplicate).not_to be_valid
  end
end
