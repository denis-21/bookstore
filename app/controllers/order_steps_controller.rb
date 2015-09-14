class OrderStepsController < ApplicationController

  before_filter :authenticate_user!
  before_action :build_step_order, only: [:show, :update]
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete


  def show
    check_step unless step.eql?(:address)
    [:address, :shipping_address, :delivery, :payment, :confirm].
        each { |s| session.delete(s) } if step.eql?(:complete)
    render_wizard
  end

  def update
    result = @step_form.update(step,step_params)
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


  def build_step_order
    @current_order =cart_user
    @step_form = OrderForm.new(@current_order)
  end

  def step_params
    params.permit(
                  shipping_address: [:first_name, :last_name, :address,:city, :country, :zipcode, :phone],
                  billing_address:  [:first_name, :last_name, :address,:city, :country, :zipcode, :phone],
                  credit_card:      [:number, :cvv, :exp_month, :exp_year],
                  delivery: [:id]
                 )
  end

end
