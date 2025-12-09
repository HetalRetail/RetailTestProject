class CreateInventoryChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_changes do |t|
      t.boolean :inventory_present
      t.references :product, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.datetime :event_time

      t.timestamps
    end
  end
end
