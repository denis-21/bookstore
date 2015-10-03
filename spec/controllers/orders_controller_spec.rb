require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  let(:user) { FactoryGirl.create(:user) }
  let(:ability) { Ability.new(user) }

  before do
    sign_in user
    allow(controller).to receive(:current_ability).and_return(ability)
    ability.can :manage, :all
    request.env['HTTP_REFERER'] = show_cart_path
  end

  let(:in_progress) { FactoryGirl.create(:order, state: 'in_progress', user: user) }
  let(:in_queue) { FactoryGirl.create(:order, state: 'in_queue', user: user) }
  let(:in_delivery) { FactoryGirl.create(:order, state: 'in_delivery', user: user) }
  let(:delivered) { FactoryGirl.create(:order, state: 'delivered', user: user) }

  describe 'GET #index' do
    context 'cancan doesnt allow :index' do
      before do
        ability.cannot :index, Order
        get :index
      end
      it { expect(response).to redirect_to(root_path) }
    end

    before { get :index }

    it 'assigns @orders' do
      expect(assigns(:orders)).to match_array [in_progress,in_queue,in_delivery,delivered]
    end

    it 'returns the first order with in_progress state' do
      expect(assigns(:in_progress)).to eq user.orders.in_progress.first
    end

    it 'fills an array of orders with an in_queue state' do
      expect(assigns(:in_queue)).to match_array [in_queue]
    end

    it 'fills an array of orders with an in_delivery state' do
      expect(assigns(:in_delivery)).to match_array [in_delivery]
    end

    it 'fills an array of orders with an delivered state' do
      expect(assigns(:delivered)).to match_array [delivered]
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end

  end

  describe 'GET #show' do

    context 'cancan doesnt allow :show' do
      before do
        ability.cannot :show, Order
        get :show, id: in_delivery
      end
      it { expect(response).to redirect_to(root_path) }
    end

    before { get :show, id: in_delivery }

    it 'assigns @order' do
      expect(assigns(:order)).to eq in_delivery
    end

    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #add_to_cart' do

    let(:book) { FactoryGirl.create(:book) }

    context 'cancan doesnt allow :add_to_cart' do
      before do
        ability.cannot :add_to_cart, Order
        post :add_to_cart, book_id: book, quantity:1
      end
      it { expect(response).to redirect_to(root_path) }
    end

    it 'redirects to shopping cart' do
      post :add_to_cart, book_id: book, quantity:1
      expect(response).to redirect_to show_cart_path
    end

  end

  describe 'PUT #update' do
    let(:order){FactoryGirl.create(:order)}
    let(:order_item){FactoryGirl.create(:order_item,order: order)}
    let(:coupon){FactoryGirl.create(:coupon)}


    context 'cancan doesnt allow :update' do
      before do
        ability.cannot :update, Order
        put :update, id: order
      end
      it { expect(response).to redirect_to(root_path) }
    end

    before do
      @items_cart = {order_item.id =>{:quantity=>'2'}}
    end

    context 'no coupon' do

      it 'assigns @order' do
        put :update, id: order,items_cart:@items_cart,discount:''
        expect(assigns(:order)).to eq (order)
      end

      it 'redirects to shopping cart' do
        put :update, id: order,items_cart:@items_cart,discount:''
        expect(response).to redirect_to show_cart_path
      end

      it 'not assigns a success flash message' do
        put :update, id: order,items_cart:@items_cart,discount:''
        expect(flash[:success]).to be_nil
      end

      it 'not assigns a warning flash message' do
        put :update, id: order,items_cart:@items_cart,discount:''
        expect(flash[:warning]).to be_nil
      end

    end

    context 'exists a coupon' do

      it 'assigns @order' do
        put :update, id: order,items_cart:@items_cart,discount:coupon.name
        expect(assigns(:order)).to eq (order)
      end

      it 'redirects to shopping cart' do
        put :update, id: order,items_cart:@items_cart,discount:coupon.name
        expect(response).to redirect_to show_cart_path
      end

      it 'assigns a success flash message' do
        put :update, id: order,items_cart:@items_cart,discount:coupon.name
        expect(flash[:success]).not_to be_nil
      end

    end

    context 'not exists a coupon' do
      it 'assigns @order' do
        put :update, id: order,items_cart:@items_cart,discount:'not'
        expect(assigns(:order)).to eq (order)
      end

      it 'redirects to shopping cart' do
        put :update, id: order,items_cart:@items_cart,discount:'not'
        expect(response).to redirect_to show_cart_path
      end

      it 'assigns a warning flash message' do
        put :update, id: order,items_cart:@items_cart,discount:'not'
        expect(flash[:warning]).not_to be_nil
      end
    end

  end

  describe 'DELETE #destroy' do
    let(:order){FactoryGirl.create(:order)}

    context 'cancan doesnt allow :destroy' do
      before do
        ability.cannot :destroy, Order
        delete :destroy, id: order
      end
      it { expect(response).to redirect_to(root_path) }
    end

    it 'assigns @order' do
      delete :destroy, id:order
      expect(assigns(:order)).to eq (order)
    end

    it 'delete order' do
      delete :destroy, id:order
      expect(Order.count).to eq 0
    end

    it 'assigns a warning flash message' do
      delete :destroy, id:order
      expect(flash[:warning]).not_to be_nil
    end

    it 'redirects to shopping cart' do
      delete :destroy, id:order
      expect(response).to redirect_to show_cart_path
    end

  end

end
