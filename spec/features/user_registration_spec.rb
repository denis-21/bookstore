require 'rails_helper'

feature 'User registration' do

  scenario 'User click sing up' do
    visit root_path
    click_link('Sing up')
    expect(current_path).to eq(new_user_registration_path)
    expect(page).to have_selector('form#new_user')
  end

  scenario 'User sing up' do
    visit new_user_registration_path
    within '#new_user' do
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: '123456'
      fill_in 'user[password_confirmation]', with: '123456'
      click_button('Sign up')
    end
    expect(page).to have_content('Welcome! You have signed up successfully')
    expect(current_path).to eq(root_path)
    expect(page).to have_content 'Cart'
    expect(page).to have_content 'Orders'
    expect(page).to have_content 'Wish list'
    expect(page).to have_content 'Settings'

  end

end