class InventoryChange < ApplicationRecord
  include Paginatable

  belongs_to :product
  belongs_to :store

  after_create :create_inventory_alert_if_needed

  scope :in_stock, -> { where(inventory_present: true) }
  scope :out_of_stock, -> { where(inventory_present: false) }

  private

  def create_inventory_alert_if_needed
    return if inventory_present

    previous = InventoryChange
      .where(product_id: product_id, store_id: store_id)
      .where.not(id: id)
      .order(event_time: :desc)
      .first

    return if previous.nil? || previous.inventory_present

    InventoryAlert.create!(
      brand: product.brand,
      product: product,
      store: store
    )
  end
end
