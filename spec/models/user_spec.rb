require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = User.new(
      name: "Sheik",
      email: "demo@gmail.com",
      password: "password123"
    )
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user = User.new(email: "demo@gmail.com", password: "password123")
    expect(user).not_to be_valid
  end

  it "rejects duplicate email" do
    User.create!(name: "A", email: "demo@gmail.com", password: "password123")
    user = User.new(name: "B", email: "demo@gmail.com", password: "password123")
    expect(user).not_to be_valid
  end
end
