require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe 'association' do
    it { should belong_to(:user)}
    it { should belong_to(:book)}
  end

  describe 'validation' do
    it { should validate_presence_of(:review) }
    it { should validate_presence_of(:rating) }
    it { should validate_numericality_of(:rating).only_integer}
    it { should validate_inclusion_of(:rating).in_range(1..5) }
  end

  context '.approved' do
    let(:rating) { FactoryGirl.create(:rating) }

    it 'not returns no confirming the rating' do
     expect(Rating.approved).not_to match_array rating
    end

    it 'returns confirming the rating' do
      rating.update(status: true)
      expect(Rating.approved).to match_array rating
    end
  end

end
