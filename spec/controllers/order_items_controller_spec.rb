require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }
  let!(:order) {FactoryGirl.create(:order,user: user)}
  let!(:order_item) {FactoryGirl.create(:order_item,order: order)}

  before do
    sign_in user
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    request.env['HTTP_REFERER'] = show_cart_path
  end



  describe 'DELETE #destroy' do
    context 'cancan doesnt allow :destroy' do
      before do
        ability.cannot :destroy, OrderItem
        delete :destroy, id:order_item
      end
      it { expect(response).to redirect_to(root_path) }
    end

    it 'assigns @order_item' do
      delete :destroy, id:order_item
      expect(assigns(:order_item)).to eq(order_item)
    end

    it 'delete item in current order' do
      delete :destroy, id:order_item
      expect(OrderItem.count).to eq 0
    end

    it 'call #recount_total_cart_price to order' do
      expect_any_instance_of(Order).to receive(:recount_total_cart_price)
      delete :destroy, id:order_item
    end


    it 'assigns a warning flash message' do
      delete :destroy, id: order_item
      expect(flash[:warning]).not_to be_nil
    end

    it 'redirects to back' do
      delete :destroy, id: order_item
      expect(response).to redirect_to show_cart_path
    end
  end

end
