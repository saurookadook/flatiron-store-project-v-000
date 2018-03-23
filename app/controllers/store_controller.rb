class StoreController < ApplicationController
  before_action :set_cart!

  def index
    @categories = Category.all
    @items = Item.all
  end
end
