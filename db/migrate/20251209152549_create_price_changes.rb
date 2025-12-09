class CreatePriceChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :price_changes do |t|
      t.integer :current_price_cents
      t.references :product, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.datetime :event_time

      t.timestamps
    end
  end
end
