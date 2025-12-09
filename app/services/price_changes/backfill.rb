module PriceChanges
  class Backfill
    DEFAULT_RECORD_COUNT = 500

    def initialize(record_count: DEFAULT_RECORD_COUNT)
      @record_count = record_count
    end

    def call
      created_count = 0

      @record_count.times do
        PriceChange.create!(
          store: random_store,
          product: random_product,
          event_time: random_date,
          current_price_cents: random_price_cents
        )

        created_count += 1
      end

      Rails.logger.info "[PriceChanges::Backfill] created=#{created_count}"
    end

    private

    def random_store
      Store.offset(rand(Store.count)).first
    end

    def random_product
      Product.offset(rand(Product.count)).first
    end

    def random_date
      Date.new(2025, 1, 1) + rand(365)
    end

    def random_price_cents
      rand(99..999999)
    end
  end
end
