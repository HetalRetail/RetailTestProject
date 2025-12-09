namespace :price_changes do
  desc "Backfill price changes with random data (default 500 records)"
  task backfill: :environment do
    record_count = ENV.fetch("RECORD_COUNT", 500).to_i

    puts "Creating #{record_count} price change records..."

    PriceChanges::Backfill.new(record_count: record_count).call

    puts "Done."
  end
end
