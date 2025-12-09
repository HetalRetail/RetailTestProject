namespace :inventory_alerts do
  desc "Backfill inventory alerts from existing inventory changes"
  task backfill: :environment do
    puts "Backfilling inventory alerts..."

    created_count = InventoryAlerts::Backfill.new.call

    puts "Done. Created #{created_count} alerts."
  end
end
