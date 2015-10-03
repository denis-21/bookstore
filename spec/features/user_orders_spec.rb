require 'rails_helper'

feature 'Orders' do
  given(:user) { FactoryGirl.create(:user)}
  before do
    login_as user
    visit root_path
  end


  scenario 'user view page all orders' do
    click_link('Orders')
    expect(page).to have_selector('h2', text: 'Orders')
    expect(current_path).to eq(orders_path)
    expect(page).to have_link('GO TO CART')
    expect(page).to have_content('IN PROGRESS')
    expect(page).to have_content('IN DELIVERY')
    expect(page).to have_content('WAITING FOR PROCESSING')
    expect(page).to have_content('DELIVERED')
  end

  context 'user is on a page with the orders' do
    given!(:book){FactoryGirl.create(:book)}
    given!(:order_in_queue){FactoryGirl.create(:order_complete_date,user: user,state:'in_queue' )}
    given!(:order_item_in_queue){FactoryGirl.create(:order_item,order: order_in_queue,book:book)}
    before do
      visit orders_path
    end

    scenario 'user click button GO TO CART' do
      click_on('GO TO CART')
      expect(current_path).to eq(show_cart_path)
      expect(page).to have_selector('h2', text: 'Shopping Cart')
    end
    scenario 'user can see order in queue ' do
      click_link('View')
      expect(current_path).to eq(order_path(order_in_queue))
      expect(page).to have_content(book.title)
      expect(page).to have_content(book.price)
      expect(page).to have_content('in_queue')
      expect(page).to have_content('ORDER TOTAL')
      expect(page).to have_content('SUBTOTAL')
      expect(page).to have_content('SHIPPING')
    end

  end

end