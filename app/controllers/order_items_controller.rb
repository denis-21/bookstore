class OrderItemsController < ApplicationController
  before_action :authenticate_user!


  def destroy
    order_item = OrderItem.find(params[:id])
    order_item.destroy
    order = order_item.order
    order.recount_total_cart_price
    flash[:warning] = 'The book successfully removed from shopping cart.'
    redirect_to (:back)
  end

end
