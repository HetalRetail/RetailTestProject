class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @inventory_changes_pagination = @product.inventory_changes.paginate(page: params[:page])
    @price_changes_pagination = @product.price_changes.paginate(page: params[:price_page])
  end
end

