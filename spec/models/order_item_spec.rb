require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'associations' do
    it { should belong_to :book }
    it { should belong_to :order }
  end

  describe 'validation' do
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
    it {should validate_numericality_of(:price).is_greater_than_or_equal_to(0.01)}
    it {should validate_numericality_of(:quantity).only_integer.is_greater_than(0)}
  end


end
