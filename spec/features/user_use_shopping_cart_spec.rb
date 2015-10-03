require 'rails_helper'

feature 'use shopping cart' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) { FactoryGirl.create(:book)}
  given!(:order) { FactoryGirl.create(:order,user: user)}
  given!(:order_item) { FactoryGirl.create(:order_item,order: order,book: book, price:book.price)}

  before do
    login_as user
    visit show_cart_path
  end


  scenario 'user removes the book from shopping cart' do
     find('a#book-remove').click
     expect(page).to have_content('The book successfully removed from shopping cart')
     expect(page).not_to have_content(book.title)
  end

  scenario 'user click button CONTINUE SHOPPING' do
    click_on('CONTINUE SHOPPING')
    expect(current_path).to eq(books_path)
  end

  scenario 'user click button EMPTY CART' do
    click_on('EMPTY CART')
    expect(page).to have_content('Your shopping cart is emptied')
  end

  scenario 'user changes the product amount' do
    fill_in "items_cart[#{order_item.id}][quantity]", with:3
    click_on('UPDATE')
    expect(page).to have_content(book.price * 3)
  end
  scenario 'user has entered a coupon ' do
    coupon = FactoryGirl.create(:coupon)
    fill_in "discount", with:coupon.name
    click_on('UPDATE')
    expect(page).to have_content('Coupon code has been accepted')
  end

  scenario 'user click CHECKOUT' do
    click_on('CHECKOUT')
    expect(page).to have_selector('h2', text: 'Checkout')
    expect(page).to have_link('address')
    expect(page).to have_link('delivery')
    expect(page).to have_link('payment')
    expect(page).to have_link('confirm')
    expect(page).to have_link('complete')
  end


end