class OrderForm
  include ActiveModel::Model


  def initialize(order)
    @current_order = order
  end

  def billing_address
    @current_order.billing_address || @current_order.user.billing_address || Address.new
  end

  def shipping_address
    @current_order.shipping_address ||  @current_order.user.shipping_address || Address.new
  end

  def delivery
    deliveries = Delivery.all.order(:price)
    @current_order.delivery ||= deliveries.first
    deliveries
  end

  def credit_card
    @current_order.user.credit_card || CreditCard.new
  end

  def complete
    @current_order.user.orders.in_queue.last
  end

  def update(step,params)
    case step
      when :address
         create_address(params[:billing_address],params[:shipping_address])
      when :delivery
        create_delivery(params[:delivery])
      when :payment
       create_payment(params[:credit_card])
      when :confirm
        @current_order.submit!
        true
    end
  end


  def create_address (billing,shipping)
    billing_address = @current_order.billing_address
    shipping_address = @current_order.shipping_address
    if billing_address && shipping_address
      billing_address.update(billing)
      shipping_address.update(shipping)
    else
      billing_address = Address.create(billing)
      shipping_address = Address.create(shipping)
    end

    if billing_address.valid? && shipping_address.valid?
      @current_order.update(billing_address: billing_address, shipping_address: shipping_address)
      true
    else
      false
    end
  end

  def create_delivery(delivery)
    if Delivery.find(delivery[:id])
      @current_order.update(delivery_id: delivery[:id])
      true
    else
      false
    end
  end


  def create_payment(payment)
    credit_card = @current_order.user.credit_card
    if credit_card
      credit_card.update(payment)
    else
      credit_card = CreditCard.create(payment)
      credit_card.user = @current_order.user
    end
    if credit_card.save
      true
    else
      false
    end
  end


end