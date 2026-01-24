require 'rails_helper'

RSpec.describe User do
  it "is invalid without email" do
    expect(User.new(password: "password123")).not_to be_valid
  end
end
