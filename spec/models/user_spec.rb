require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:book) { FactoryGirl.create(:book) }
  let(:book2) { FactoryGirl.create(:book) }

  describe 'associations' do
    it { should have_and_belong_to_many(:books) }
    it { should have_many(:orders) }
    it { should have_many(:ratings).dependent(:destroy) }
    it { should belong_to(:billing_address) }
    it { should belong_to(:shipping_address) }
    it { should have_one(:credit_card).dependent(:destroy) }
  end

  describe '#book_in_wishlist?' do
    it 'returns true if a book in the wish list' do
      user.add_to_wishlist(book)
      expect(user.book_in_wishlist?(book)).to be_truthy
    end
  end

  describe '#add_to_wishlist' do
    before do
      user.add_to_wishlist(book)
      user.add_to_wishlist(book2)
    end

    it 'add a book to the wish list' do
      expect(user.books).to match_array [book, book2]
    end

    it 'add same book to the wish list twice' do
      expect { user.add_to_wishlist(book) }.
          to raise_error ActiveRecord::RecordNotUnique
    end
  end

  describe '#delete_from_wishlist' do
    before do
      user.add_to_wishlist(book)
      user.add_to_wishlist(book2)
    end

    it 'delete a book to the wish list' do
      user.delete_from_wishlist(book2)
      expect(user.books).to match_array [book]
    end
  end

  describe '#facebook_login' do
    let(:auth) do
      user = attributes_for :facebook_user
      double("auth",
             provider: user[:provider],
             uid: user[:uid],
             info: double("info",
                          email: user[:email],

             )
      )
    end

    it 'create new user' do
      expect(User.facebook_login(auth)).to be_instance_of(User)
    end

    it 'user have email' do
      expect(User.facebook_login(auth)).to respond_to(:email)
    end

    it 'user have password' do
      expect(User.facebook_login(auth)).to respond_to(:password)
    end

  end

end
