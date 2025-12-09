class InventoryAlertsController < ApplicationController
  def index
    @brand = Brand.find(params[:brand_id])
    @inventory_alerts = @brand.inventory_alerts.includes(:product, :store)
  end

  def show
    @brand = Brand.find(params[:brand_id])
    @inventory_alert = @brand.inventory_alerts.find(params[:id])
  end
end
