require 'rails_helper'

RSpec.describe OrderStepsController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let!(:order) { FactoryGirl.create(:order,user: user)}


  before do
    sign_in user
  end

  describe 'GET #show' do

    context 'show_address' do
      before do
        get :show, id: :address
      end

      it 'not call#check_step ' do
        expect(controller).not_to receive(:check_step)
      end

      it 'render the address template' do
        expect(response).to render_template('address')
      end

    end

    context 'show_delivery' do
      before do
        allow(controller).to receive_messages(:check_step => nil)
        get :show, id: :delivery
      end

      it 'render the delivery template' do
        expect(response).to render_template('delivery')
      end

    end

    context 'show payment' do
      before do
        allow(controller).to receive_messages(:check_step => nil)
        get :show, id: :payment
      end

      it 'render the payment template' do
        expect(response).to render_template('payment')
      end

    end

    context 'show confirm' do
      before do
        allow(controller).to receive_messages(:check_step => nil)
        get :show, id: :confirm
      end

      it 'render the confirm template' do
        expect(response).to render_template('confirm')
      end

    end

    context 'show complete' do
      before do
        allow(controller).to receive_messages(:check_step => nil)
      end

      it 'render the complete template' do
        get :show, id: :complete
        expect(response).to render_template('complete')
      end

      context 'session' do
        before  do
          session['address'] = true
          session['delivery'] = true
          session['payment'] = true
          session['confirm'] = true
        end
        it 'session order form destroy' do
             get :show, id: :complete
            expect(session).not_to include('address','delivery','payment','confirm')
        end
      end
    end

  end

  describe 'PATH #update' do

    before do
      @params = { id: :address, billing_address: FactoryGirl.attributes_for(:address),
                  shipping_address: FactoryGirl.attributes_for(:address) }
    end

    it 'build order' do
      patch :update, @params
      expect(assigns(:step_form)).not_to be_nil
    end


    context 'return true order form update' do
      it 'setting session in true' do
        patch :update, @params
        expect(session['address']).to eq true
      end

      it 'next step if order save' do
        patch :update, @params
        expect(response).to redirect_to(action: :show,id: :delivery)
      end

    end

    context ' return false order form update' do
      before do
        @params[:billing_address][:address] = nil
      end

      it 'setting session in nil' do
        patch :update, @params
        expect(session['address']).to be_nil
      end

      it 'render current step if order not save' do
        patch :update, @params
        expect(response).to render_template('address')
      end

    end

  end

end
