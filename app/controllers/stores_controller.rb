class StoresController < ApplicationController
  def index
    @stores = Store.all
  end

  def show
    @store = Store.find(params[:id])
    @inventory_changes_pagination = @store.inventory_changes.paginate(page: params[:page])
  end
end

