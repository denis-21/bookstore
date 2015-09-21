require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { FactoryGirl.create(:book) }

  describe 'associations' do
    it { should belong_to(:category) }
    it { should belong_to(:author) }
    it { should have_and_belong_to_many(:users) }
    it { should have_many(:order_items) }
    it { should have_many(:ratings).dependent(:destroy) }
  end

  describe 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:stock) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:description) }
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0.01)}
  end

  context '.search(text)' do

    it 'returns a book by text' do
      expect(Book.search(book.title)).to match_array([book])
    end
    it 'returns a book by author' do
      expect(Book.search(book.author.first_name)).to match_array([book])
    end
  end


  describe 'default scope' do
    it 'returns books in descending order' do
      book1 = FactoryGirl.create :book
      book2 = FactoryGirl.create :book
      expect(Book.all).to match_array [book2, book1, book]
    end
  end

end
