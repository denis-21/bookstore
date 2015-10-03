require 'rails_helper'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      let(:user) { nil }
      subject(:ability){ Ability.new(user) }

      context 'when is account admin' do
        let(:user)  { FactoryGirl.create(:admin) }
        it { expect(ability).to be_able_to(:manage, :all) }
      end

      context 'when is account user' do
        let(:user)  { FactoryGirl.create(:user) }

        context 'book' do
          it { expect(ability).to be_able_to(:index, Book.new) }
          it { expect(ability).to be_able_to(:show, Book.new) }
          it { expect(ability).to be_able_to(:add_to_wishlist, Book.new) }
          it { expect(ability).to be_able_to(:wishlist, Book.new) }
          it { expect(ability).to be_able_to(:delete_from_wishlist, Book.new) }
          it { expect(ability).not_to be_able_to(:create, Book.new) }
          it { expect(ability).not_to be_able_to(:update, Book.new) }
          it { expect(ability).not_to be_able_to(:destroy, Book.new) }
        end

        context 'rating' do
          it { expect(ability).to be_able_to(:new, Rating.new(user: user))}
          it { expect(ability).not_to be_able_to(:new, Rating.new)}
          it { expect(ability).to be_able_to(:create, Rating.new(user: user))}
          it { expect(ability).not_to be_able_to(:create, Rating.new)}
          it { expect(ability).to be_able_to(:read, Rating.new)}
          it { expect(ability).not_to be_able_to(:edit, Rating.new) }
          it { expect(ability).not_to be_able_to(:destroy, Rating.new) }
        end

        context 'Category' do
          it { expect(ability).to be_able_to(:read, Category.new)}
          it { expect(ability).not_to be_able_to(:create, Category.new) }
          it { expect(ability).not_to be_able_to(:edit, Category.new) }
          it { expect(ability).not_to be_able_to(:destroy, Category.new) }
        end

        context 'OrderItem' do

          it { expect(ability).to be_able_to(:destroy, OrderItem.new(order: user.orders.in_progress.first))}
          it do
            order_item = FactoryGirl.create(:order_item)
            expect(ability).not_to be_able_to(:destroy, OrderItem.new(order: order_item.order))
          end
          it { expect(ability).not_to be_able_to(:create, OrderItem.new) }
          it { expect(ability).not_to be_able_to(:edit, OrderItem.new) }
          it { expect(ability).not_to be_able_to(:read, OrderItem.new) }
        end

        context 'Order' do
          it { expect(ability).to be_able_to(:manage, Order.new(user: user)) }
          it { expect(ability).not_to be_able_to(:manage, Order.new) }
        end

      end

      context 'when is not sing in account' do

        context 'book' do
          it { expect(ability).to be_able_to(:read, Book.new) }
          it { expect(ability).not_to be_able_to(:add_to_wishlist, Book.new) }
          it { expect(ability).not_to be_able_to(:wishlist, Book.new) }
          it { expect(ability).not_to be_able_to(:delete_from_wishlist, Book.new) }
          it { expect(ability).not_to be_able_to(:create, Book.new) }
          it { expect(ability).not_to be_able_to(:update, Book.new) }
          it { expect(ability).not_to be_able_to(:destroy, Book.new) }
        end

        context 'rating' do
          it { expect(ability).to be_able_to(:read, Rating.new)}
          it { expect(ability).not_to be_able_to(:new, Rating.new)}
          it { expect(ability).not_to be_able_to(:create, Rating.new)}
          it { expect(ability).not_to be_able_to(:edit, Rating.new) }
          it { expect(ability).not_to be_able_to(:destroy, Rating.new) }
        end

        context 'Category' do
          it { expect(ability).to be_able_to(:read, Category.new)}
          it { expect(ability).not_to be_able_to(:create, Category.new) }
          it { expect(ability).not_to be_able_to(:edit, Category.new) }
          it { expect(ability).not_to be_able_to(:destroy, Category.new) }
        end

        context 'OrderItem' do
          it { expect(ability).not_to be_able_to(:destroy, OrderItem.new)}
          it { expect(ability).not_to be_able_to(:create, OrderItem.new) }
          it { expect(ability).not_to be_able_to(:edit, OrderItem.new) }
          it { expect(ability).not_to be_able_to(:read, OrderItem.new) }
        end

        context 'Order' do
          it { expect(ability).not_to be_able_to(:manage, Order.new) }
        end

      end

    end
  end
end
