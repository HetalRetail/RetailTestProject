class Brand < ApplicationRecord
    has_many :products
    has_many :inventory_alerts
end
