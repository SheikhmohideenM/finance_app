# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create!(
  name: "sheik",
  email: "demo@gmail.com",
  password: "password123"
)

account = user.accounts.create!(name: "Cash", balance: 1000)
category = user.categories.create!(name: "Food", monthly_budget: 500)

Transaction.create!(
  account: account,
  category: category,
  amount: -150,
  date: Date.today,
  description: "Groceries"
)
