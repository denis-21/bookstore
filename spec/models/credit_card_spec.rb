require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create(:credit_card) }

  describe 'associations' do
    it { should belong_to :user }
  end

  describe 'validation' do
    it { should validate_presence_of :number }
    it { should validate_presence_of :exp_month }
    it { should validate_presence_of :exp_year }
    it { should validate_presence_of :cvv }
    it { should validate_length_of(:number).is_equal_to(16) }
    it { should validate_length_of(:exp_month).is_at_most(2) }
    it { should validate_length_of(:exp_year).is_equal_to(4) }
    it { should validate_length_of(:cvv).is_equal_to(3) }
  end

  describe '#last_digits' do
    let(:last_digits) {credit_card.last_digits}

    it 'returns last four digits' do
      expect(last_digits).to eq credit_card.number[-4..-1]
    end
  end

  describe '#mask' do
    it 'returns hidden numbers except the last four' do
      expect(credit_card.mask).to eq "**** **** **** #{credit_card.last_digits}"
    end
  end

  describe '#date' do
    it 'returns an expiration date' do
      expect(credit_card.date).to eq "#{credit_card.exp_month}/#{credit_card.exp_year}"
    end
  end

end
