class OrdersController < ApplicationController
  load_and_authorize_resource

  def index
    orders = current_user.orders
    @in_progress = orders.in_progress.first
    @in_queue = orders.in_queue
    @in_delivery = orders.in_delivery
    @delivered = orders.delivered
  end

  def show
    @order = Order.find(params[:id])
  end

  def show_cart
    @current_order = cart_user
    @items_cart = @current_order.order_items
  end

  def create
    book = Book.find(params[:book_id])
    current_order = cart_user
    current_order.add_item_to_cart(book,params[:quantity].to_i)
    redirect_to show_cart_orders_path
  end


  def update
      order = Order.find(params[:id])
      order.update_cart(params[:items_cart])
      redirect_to (:back)
  end

  def destroy
    order = Order.find(params[:id])
    order.destroy
    flash[:warning] = 'Your shopping cart is emptied.'
    redirect_to (:back)
  end
end
