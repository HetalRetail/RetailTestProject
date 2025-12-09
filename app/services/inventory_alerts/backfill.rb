module InventoryAlerts
  class Backfill
    def call
      created_count = 0

      InventoryChange.where(inventory_present: false).find_each do |inventory_change|
        previous = InventoryChange
          .where(product_id: inventory_change.product_id, store_id: inventory_change.store_id)
          .where.not(id: inventory_change.id)
          .where("event_time < ?", inventory_change.event_time)
          .order(event_time: :desc)
          .first

        next if previous.nil? || previous.inventory_present

        alert = InventoryAlert.find_or_create_by!(
          brand: inventory_change.product.brand,
          product: inventory_change.product,
          store: inventory_change.store,
          created_at: inventory_change.created_at
        )

        created_count += 1 if alert.previously_new_record?
      end

      Rails.logger.info "[InventoryAlerts::Backfill] created=#{created_count}"
      created_count
    end
  end
end
