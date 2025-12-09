class Store < ApplicationRecord
    has_many :inventory_changes
    has_many :inventory_alerts
end
