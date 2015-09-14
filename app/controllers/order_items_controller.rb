class OrderItemsController < ApplicationController
  load_and_authorize_resource :only => [:destroy]


  def destroy
    @order_item.destroy
    order = @order_item.order
    order.recount_total_cart_price
    flash[:warning] = 'The book successfully removed from shopping cart.'
    redirect_to (:back)
  end

end
