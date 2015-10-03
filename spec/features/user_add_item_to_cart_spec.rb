require 'rails_helper'

feature 'Add item to shopping cart' do
  given!(:book) {FactoryGirl.create(:book)}
  before do
    visit book_path(book.id)
  end


  scenario 'User is not login' do
    click_button('Add to Cart')
    expect(page).to have_content('You are not authorized to access this page')
    expect(current_path).to eq(root_path)

  end

  context 'User login' do
    given(:user) { FactoryGirl.create(:user)}
    background do
      login_as user
    end

    scenario 'User add book to cart' do
      click_button('Add to Cart')
      expect(current_path).to eq(show_cart_path)
      expect(page).to have_content  book.title
      expect(page).to have_content  book.price
    end

    scenario 'User adds an existing book to cart' do
      click_button('Add to Cart')
      visit book_path(book.id)
      click_button('Add to Cart')

      expect(current_path).to eq(show_cart_path)
      expect(page).to have_content  book.title
      expect(page).to have_content  book.price
      expect(page).to have_selector("input.quantity[value='2']")
    end


  end


end