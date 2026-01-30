require "rails_helper"
RSpec.describe Pot, type: :model do
  it "calculates percentage correctly" do
    pot = Pot.new(target: 1000, saved: 250)
    expect(pot.percent).to eq(25.0)
  end
end
