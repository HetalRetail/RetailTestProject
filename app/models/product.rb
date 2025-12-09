class Product < ApplicationRecord
    belongs_to :brand
    has_many :inventory_changes
    has_many :price_changes
end
