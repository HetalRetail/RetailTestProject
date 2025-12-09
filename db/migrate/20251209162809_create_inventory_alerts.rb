class CreateInventoryAlerts < ActiveRecord::Migration[7.1]
  def change
    create_table :inventory_alerts do |t|
      t.references :brand, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
