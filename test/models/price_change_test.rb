require "test_helper"

class PriceChangeTest < ActiveSupport::TestCase
  test "validation rejects nil current_price_cents" do
    price_change = PriceChange.new(current_price_cents: nil)
    assert_not price_change.valid?
    assert_includes price_change.errors[:current_price_cents], "is not a number"
  end

  test "validation rejects negative current_price_cents" do
    price_change = PriceChange.new(current_price_cents: -1)
    assert_not price_change.valid?
    assert_includes price_change.errors[:current_price_cents], "must be greater than or equal to 0"
  end

  test "#formatted_price returns currency string with dollar sign and commas" do
    price_change = PriceChange.new(current_price_cents: 810344)
    assert_equal "$8,103.44", price_change.formatted_price
  end

  test "#formatted_price handles zero cents" do
    price_change = PriceChange.new(current_price_cents: 0)
    assert_equal "$0.00", price_change.formatted_price
  end

  test "#formatted_price handles small amounts" do
    price_change = PriceChange.new(current_price_cents: 99)
    assert_equal "$0.99", price_change.formatted_price
  end
end
