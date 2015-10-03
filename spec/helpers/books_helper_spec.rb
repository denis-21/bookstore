require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BooksHelper. For example:
#
# describe BooksHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BooksHelper, type: :helper do

  describe '#exist_in_wish_list' do
    context 'is user' do
      let(:user) { create :user }
      let(:book) { create :book }
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
        allow(helper).to receive(:current_user).and_return(user)
      end

      it 'exist book wish list' do
        allow(user).to receive(:book_in_wishlist?).and_return(true)
        expect(helper.exist_in_wish_list(book)).to include ('In wish list')
      end

=begin
      it 'not exist book in wish list' do
        allow(user).to receive(:book_in_wishlist?).and_return(false)
        expect(helper.exist_in_wish_list(book)).to include ('Add to Wishlist')
      end
=end

    end
    context 'not user' do
      let(:book) { create :book }
      before do
        allow(helper).to receive(:user_signed_in?).and_return(false)
      end

      it 'return nil' do
        expect(helper.exist_in_wish_list(book)).to be_nil
      end
    end

  end

end
