class InventoryAlert < ApplicationRecord
  belongs_to :brand
  belongs_to :product
  belongs_to :store

  def last_in_stock
    related_inventory_changes
      .in_stock
      .where("event_time < ?", created_at)
      .order(event_time: :desc)
      .first
  end

  def last_in_stock_at
    last_in_stock&.event_time
  end

  def consecutive_out_of_stock_count
    scope = related_inventory_changes.out_of_stock
    scope = scope.where("id > ?", last_in_stock.id) if last_in_stock
    scope.count
  end

  private

  def related_inventory_changes
    InventoryChange.where(product_id: product_id, store_id: store_id)
  end
end
