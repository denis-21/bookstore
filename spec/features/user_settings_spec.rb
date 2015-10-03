require 'rails_helper'

feature 'User click book' do
  given(:user) { FactoryGirl.create(:user)}
  before do
    login_as user
  end


  scenario 'user view setting page' do
    visit root_path
    click_link('Settings')
    expect(current_path).to eq(edit_user_registration_path(user))
  end


  context 'user is on a page with the settings' do
    given(:address) { attributes_for :address }
    before do
      visit edit_user_registration_path(user)
    end


    scenario 'edit user data' do
      within '#edit_user' do
        fill_in 'user[email]', with:user.email
        fill_in 'user[password]', with:'12345678'
        fill_in 'user[password_confirmation]', with:'12345678'
        fill_in 'user[password_confirmation]', with:'12345678'
        fill_in 'user[current_password]', with:'123456'
        click_on('Update')
      end
      expect(page).to have_content('Your account has been updated successfully')
    end

    scenario 'user edit billing address' do
      within '#billing_address' do
        fill_in 'billing_address[first_name]', with:address[:first_name]
        fill_in 'billing_address[last_name]', with:address[:last_name]
        fill_in 'billing_address[address]', with:address[:address]
        fill_in 'billing_address[phone]', with:address[:phone]
        fill_in 'billing_address[city]', with:address[:city]
        fill_in 'billing_address[country]', with:address[:country]
        fill_in 'billing_address[zipcode]', with:address[:zipcode]
        click_on('Save')
      end
      expect(page).to have_content (I18n.t("devise.registrations.billing_address_saved"))
    end

    scenario 'user edit shipping address' do
      within '#shipping_address' do
        fill_in 'shipping_address[first_name]', with:address[:first_name]
        fill_in 'shipping_address[last_name]', with:address[:last_name]
        fill_in 'shipping_address[address]', with:address[:address]
        fill_in 'shipping_address[phone]', with:address[:phone]
        fill_in 'shipping_address[city]', with:address[:city]
        fill_in 'shipping_address[country]', with:address[:country]
        fill_in 'shipping_address[zipcode]', with:address[:zipcode]
        click_on('Save')
      end
      expect(page).to have_content (I18n.t("devise.registrations.shipping_address_saved"))
    end
  end

end