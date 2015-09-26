require 'rails_helper'

RSpec.describe Order, type: :model do

  let(:order) { FactoryGirl.create(:order) }

  describe 'associations' do
    it { should have_many(:order_items).dependent(:destroy) }
    it { should belong_to :user }
    it { should belong_to :delivery }
    it { should belong_to(:billing_address) }
    it { should belong_to(:shipping_address) }
    it { should belong_to :coupon }
  end

  describe 'validation' do
    it { should validate_presence_of :state }
    it { should validate_inclusion_of(:state).in_array(%w(in_progress in_queue in_delivery delivered canceled))}

  end

  context 'AASM' do

    it 'by default have in_progress state' do
      expect(order.state).to eq 'in_progress'
    end

    it '#submit transitions from in_progress to in_queue' do
      order.submit!
      expect(order.state).to eq 'in_queue'
      expect(order.completed_at).not_to eq nil
    end

    it '#ship transitions from in_queue to in_delivery' do
      order.submit!
      order.ship!
      expect(order.state).to eq 'in_delivery'
    end

    it '#complete transitions from in_delivery to delivered' do
      order.submit!
      order.ship!
      order.complete!
      expect(order.state).to eq 'delivered'
    end

    it '#cancel transitions from in_progress, in_queue, in_delivery to canceled' do
      order.cancel!
      expect(order.state).to eq 'canceled'
    end

  end

  describe '#add_item_to_cart' do
    let(:book) { FactoryGirl.create(:book) }

    it 'add a new item to cart to the amount of one or less' do
        order.add_item_to_cart(book,1)
        current_item = order.order_items.first
        expect(current_item.book).to eq book
        expect(current_item.quantity).to eq 1
        expect(current_item.price).to eq 1 * book.price
    end

    it 'add two identical item in cart' do
      order.add_item_to_cart(book,1)
      order.add_item_to_cart(book,1)
      current_item = order.order_items.first
      expect(current_item.quantity).to eq 2
      expect(current_item.price).to eq 2 * book.price
    end

  end

  describe '#recount_total_cart_price' do
    it 'sum of all the items in shopping cart' do
      book = FactoryGirl.create(:book)
      book2 = FactoryGirl.create(:book)
      FactoryGirl.create(:order_item,order: order,book: book,price:book.price)
      FactoryGirl.create(:order_item,order: order,book: book2,price:book2.price)
      order.recount_total_cart_price
      expect(order.total_price).to eq (book.price + book2.price)
    end
  end

  describe '#update_cart' do
    let(:book) { FactoryGirl.create(:book) }
    let(:book2) { FactoryGirl.create(:book) }
    before do
      item = FactoryGirl.create(:order_item,order: order,book: book,price:book.price)
      item2 = FactoryGirl.create(:order_item,order: order,book: book2,price:book2.price)
      @items = {item.id =>{:quantity=>'2'},item2.id =>{:quantity=>'3'}}
    end
    it 'update quantity items in shopping cart' do
      order.update_cart(@items)
      expect(order.total_price).to eq (book.price * 2 + book2.price* 3)
    end

    it 'update quantity items in shopping cart and add coupon' do
      coupon = FactoryGirl.create(:coupon)
      order.update_cart(@items,coupon)
      expect(order.coupon).to eq coupon
    end
  end

  describe '#discount_price' do
    let(:book) { FactoryGirl.create(:book) }
    before do
      order.add_item_to_cart(book,3)
    end
    it 'return price considering coupon' do
      coupon = FactoryGirl.create(:coupon)
      order.coupon = coupon
      expect(order.discount_price).to eq (order.total_price - order.total_price * (coupon.discount / 100.0))
    end

    it 'return price not considering coupon' do
      expect(order.discount_price).to eq order.total_price
    end
  end

  describe '#complete_date' do
    it 'update complete date in order' do
       order.complete_date
       expect(order.completed_at).not_to eq nil
    end
  end


end
