require 'rails_helper'

RSpec.describe Author, type: :model do

  describe 'associations' do
    it { should have_many  :books }
  end

  describe 'validation' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :description }

  end


end
