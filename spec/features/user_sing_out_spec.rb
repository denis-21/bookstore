require 'rails_helper'

feature 'User Sing Out' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) {FactoryGirl.create(:book)}
  before do
    login_as user
    visit root_path
  end


  scenario 'User click link Sing Out' do
    click_link('Sing out')
    expect(page).to have_content ('Signed out successfully')
  end

end