class PriceChange < ApplicationRecord
  belongs_to :product
  belongs_to :store

  validates :current_price_cents, numericality: { greater_than_or_equal_to: 0 }

  def formatted_price
    ActiveSupport::NumberHelper.number_to_currency(current_price_cents / 100.0)
  end
end
