class OrderStepsController < ApplicationController

  before_filter :authenticate_user!

  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete


  def show
    @current_order = cart_user
    case step
      when :address
        @billing_address ||= @current_order.billing_address || current_user.billing_address || Address.new
        @shipping_address ||= @current_order.shipping_address || current_user.shipping_address || Address.new
      when :delivery
        check_step
        @deliveries = Delivery.all.order(:price)
        @current_order.delivery ||= @deliveries.first
      when :payment
        check_step
        @credit_card = current_user.credit_card || CreditCard.new
      when :confirm
        check_step
        @shipping_address = @current_order.shipping_address
        @billing_address = @current_order.billing_address
      when :complete
        check_step
        @order = current_user.orders.in_queue.last
        @shipping_address = @order.shipping_address
        @billing_address = @order.billing_address
        [:billing_address, :shipping_address, :delivery, :payment, :confirm].
            each { |s| session.delete(s) }

    end
    render_wizard
  end

  def update
    @current_order = cart_user

    case step
      when :address
        result = create_address(@current_order,address_params(:billing_address),address_params(:shipping_address))
      when :delivery
         result = @current_order.create_delivery(delivery_params)
      when :payment
         result = create_payment(payment_params)
      when :confirm
        @current_order.submit!
        result = true
    end

    if result
      session[step.to_sym] = true
      redirect_to next_wizard_path
    else
      session[step.to_sym] = nil
      render_wizard
    end
  end


  private
    def check_step
      jump_to(previous_step.to_sym) if session[previous_step.to_sym].nil?
    end


    def create_address (current_order,billing,shipping)
      billing_address = current_order.billing_address
      shipping_address = current_order.shipping_address
      if billing_address && shipping_address
          billing_address.update(billing)
          shipping_address.update(shipping)
      else
        billing_address = Address.create(billing)
        shipping_address = Address.create(shipping)
      end
      @billing_address = billing_address
      @shipping_address = shipping_address
      if @billing_address.valid? && @shipping_address.valid?
        current_order.update(billing_address: @billing_address, shipping_address: @shipping_address)
        true
      else
        false
      end
    end


    def create_payment(payment)
      credit_card = current_user.credit_card
      if credit_card
        credit_card.update(payment)
      else
        credit_card = CreditCard.create(payment)
      end
      @credit_card = credit_card
      if @credit_card.save
        true
      else
        false
      end
    end



    def address_params(type)
      params.require(type).permit(:first_name, :last_name, :address,:city, :country, :zipcode, :phone)
    end

    def delivery_params
      params[:delivery] if Delivery.find(params[:delivery])
    end

    def payment_params
      params.require(:credit_card).permit(:number, :cvv, :exp_month, :exp_year)
    end

end
