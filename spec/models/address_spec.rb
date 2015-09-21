require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { FactoryGirl.create(:address) }

  describe 'associations' do
    it { should belong_to :user }
  end

  describe 'validation' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :phone }
    it { should validate_presence_of :city }
    it { should validate_presence_of :country }
    it { should validate_presence_of :zipcode }
    it { should validate_length_of(:zipcode).is_equal_to(5) }
    it { should validate_length_of(:phone).is_at_least(5).is_at_most(12) }
  end



end
