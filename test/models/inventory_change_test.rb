require "test_helper"

class InventoryChangeTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "Test Brand")
    @product = Product.create!(name: "Test Product", brand: @brand)
    @store = Store.create!(address: "123 Test St")
    @other_product = Product.create!(name: "Other Product", brand: @brand)
    @other_store = Store.create!(address: "456 Other St")
  end

  test "does not create alert when inventory is present" do
    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: true,
        event_time: 1.day.ago
      )
    end
  end

  test "does not create alert for first out of stock record" do
    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end

  test "does not create alert when previous record was in stock" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: true,
      event_time: 2.days.ago
    )

    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end

  test "creates alert when previous record was also out of stock" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 2.days.ago
    )

    assert_difference "InventoryAlert.count", 1 do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end

  test "created alert has correct associations" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 2.days.ago
    )

    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 1.day.ago
    )

    alert = InventoryAlert.last
    assert_equal @brand, alert.brand
    assert_equal @product, alert.product
    assert_equal @store, alert.store
  end

  test "creates alert for each consecutive out of stock after the first" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 3.days.ago
    )

    assert_difference "InventoryAlert.count", 2 do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 2.days.ago
      )

      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end

  test "does not create alert for different product/store combo" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 2.days.ago
    )

    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @other_product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end

    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @product,
        store: @other_store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end

  test "resets alert creation after in stock record" do
    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: false,
      event_time: 3.days.ago
    )

    InventoryChange.create!(
      product: @product,
      store: @store,
      inventory_present: true,
      event_time: 2.days.ago
    )

    assert_no_difference "InventoryAlert.count" do
      InventoryChange.create!(
        product: @product,
        store: @store,
        inventory_present: false,
        event_time: 1.day.ago
      )
    end
  end
end
