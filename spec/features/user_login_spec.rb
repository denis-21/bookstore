require 'rails_helper'

feature 'Login' do


  before { visit new_user_session_path }

  scenario 'Visitor login in user successfully via login form(user)' do
    user = FactoryGirl.create(:user)

    within '#new_user' do
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button('Sing in')
    end

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content 'Cart'
    expect(page).to have_content 'Orders'
    expect(page).to have_content 'Wish list'
    expect(page).to have_content 'Settings'
    expect(page).not_to have_content 'Admin'
  end

  scenario 'Visitor login in user successfully via login form(admin)' do
    admin = FactoryGirl.create(:admin)

    within '#new_user' do
      fill_in 'user[email]', with: admin.email
      fill_in 'user[password]', with: admin.password
      click_button('Sing in')
    end

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content 'Cart'
    expect(page).to have_content 'Orders'
    expect(page).to have_content 'Wish list'
    expect(page).to have_content 'Settings'
    expect(page).to have_content 'Admin'
  end

  scenario 'Visitor login failure via register form' do

    within '#new_user' do
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      click_button('Sing in')
    end

    expect(page).to have_content 'Invalid email or password.'
  end

end