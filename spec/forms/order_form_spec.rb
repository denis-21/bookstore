require 'rails_helper'

RSpec.describe OrderForm, type: :model do

  let!(:order) { FactoryGirl.create(:order) }
  subject(:order_form) { OrderForm.new(order) }

  it { expect(order_form).to respond_to(:billing_address) }
  it { expect(order_form).to respond_to(:shipping_address) }
  it { expect(order_form).to respond_to(:delivery) }
  it { expect(order_form).to respond_to(:credit_card) }
  it { expect(order_form).to respond_to(:complete) }

  describe '#create_address' do
    let(:billing) { FactoryGirl.attributes_for(:address) }
    let(:shipping) { FactoryGirl.attributes_for(:address) }

    context 'when update address' do
      before do
         order.billing_address = FactoryGirl.create(:address)
         order.shipping_address = FactoryGirl.create(:address)
      end
      it 'update address at order' do
        order_form.create_address(billing,shipping)
        expect(order.billing_address.address).to eq (billing[:address])
        expect(order.shipping_address.address).to eq (shipping[:address])

      end

      it 'not create additional two addresses if update' do
        expect{order_form.create_address(billing, shipping)}.not_to change{ Address.count }
      end
    end

    context 'when create address' do
      it 'update address at order' do
        order_form.create_address(billing,shipping)
        expect(order.billing_address.address).to eq (billing[:address])
        expect(order.shipping_address.address).to eq (shipping[:address])
      end

      it 'create two new addresses' do
        expect{order_form.create_address(billing, shipping)}.to change{ Address.count }.from(0).to(2)
      end
    end
  end

  describe '#create_delivery' do
    let(:delivery) { FactoryGirl.create(:delivery) }
    let(:params_delivery) { { id: delivery.id } }

    it 'update delivery at order' do
      result = order_form.create_delivery(params_delivery)
      expect(order.delivery).to eq delivery
      expect(result).to eq true
    end

    it 'not find id delivery' do
      expect{order_form.create_delivery({id:9999})}.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe '#create_payment' do
    let(:credit_card) { FactoryGirl.attributes_for(:credit_card) }

    context 'when update credit card' do
      before do
        order.user.credit_card = FactoryGirl.create(:credit_card)
      end

      it 'update user credit card' do
        order_form.create_payment(credit_card)
        expect(order.user.credit_card.number).to eq (credit_card[:number])
      end

      it 'not create credit card' do
        expect{ order_form.create_payment(credit_card)}.not_to change{ CreditCard.count }
      end
    end

    context ' when create credit card' do

      it 'update user credit card' do
        order_form.create_payment(credit_card)
        expect(order.user.credit_card.number).to eq (credit_card[:number])
      end

      it 'create credit card' do
        expect{ order_form.create_payment(credit_card)}.to change{ CreditCard.count }.from(0).to(1)
      end
    end

    describe '#update' do

      before do
        @params = { billing_address: FactoryGirl.attributes_for(:address),
                    shipping_address: FactoryGirl.attributes_for(:address),
                    delivery: '1',
                    credit_card: FactoryGirl.attributes_for(:credit_card)}
      end

      it 'create address if address step' do
        expect(order_form).to receive(:create_address).with(@params[:billing_address], @params[:shipping_address])
        order_form.update(:address, @params)
      end

      it 'create delivery if delivery step' do
        expect(order_form).to receive(:create_delivery).with(@params[:delivery])
        order_form.update(:delivery, @params)
      end

      it 'create credit card if payment step' do
        expect(order_form).to receive(:create_payment).with(@params[:credit_card])
        order_form.update(:payment, @params)
      end

      it 'create order if confirm step' do
        expect(order).to receive(:submit!)
        order_form.update(:confirm, @params)
      end

    end

  end

end
