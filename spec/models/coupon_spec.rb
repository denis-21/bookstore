require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:coupon) { FactoryGirl.create(:coupon) }

  describe 'associations' do
    it { should have_many :order }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:discount) }
    it { should validate_presence_of(:expires_at) }
    it { should validate_uniqueness_of(:name) }
  end

  context '.active' do

    it 'return a coupons where the date is greater than or today' do
      expect(Coupon.active).to match_array([coupon])
    end

  end

end


