require 'rails_helper'

feature 'User checkout' do
  given(:user) { FactoryGirl.create(:user)}
  given!(:book) { FactoryGirl.create(:book)}
  given!(:order) { FactoryGirl.create(:order,user: user)}
  given!(:order_item) { FactoryGirl.create(:order_item,order: order,book: book, price:book.price)}
  given!(:delivery) { FactoryGirl.create(:delivery)}

  before do
   login_as user
  end

  scenario 'User view address step' do
    visit order_step_path(:address)
    fill_address
    click_on('SAVE AND CONTINUE')
    expect(current_path).to eq(order_step_path(:delivery))
    expect(find_link('delivery')[:class]).to match(/active/)
  end

  scenario 'User view delivery step' do
    visit order_step_path(:address)
    fill_address
    click_on('SAVE AND CONTINUE')
    click_on('SAVE AND CONTINUE')

    expect(current_path).to eq(order_step_path(:payment))
    expect(find_link('payment')[:class]).to match(/active/)
  end

  scenario 'User view payment step' do
    visit order_step_path(:address)
    fill_address
    click_on('SAVE AND CONTINUE')
    click_on('SAVE AND CONTINUE')
    fill_payment
    click_on('SAVE AND CONTINUE')

    expect(current_path).to eq(order_step_path(:confirm))
    expect(find_link('confirm')[:class]).to match(/active/)
    expect(page).to have_content(order.delivery.name)
    expect(page).to have_content(user.credit_card.exp_year)
    expect(page).to have_content(user.credit_card.number.to_s.slice(-4..-1))

  end

  scenario 'User view confirm step' do
    visit order_step_path(:address)
    fill_address
    click_on('SAVE AND CONTINUE')
    click_on('SAVE AND CONTINUE')
    fill_payment
    click_on('SAVE AND CONTINUE')
    click_on('PLACE ORDER')

    expect(current_path).to eq(order_step_path(:complete))
    expect(page).not_to have_content('Checkout')
    expect(page).to have_content(order.delivery.name)
    expect(page).to have_content(user.credit_card.exp_year)
    expect(page).to have_content(user.credit_card.number.to_s.slice(-4..-1))
  end


  scenario 'User view complete step' do
    visit order_step_path(:address)
    fill_address
    click_on('SAVE AND CONTINUE')
    click_on('SAVE AND CONTINUE')
    fill_payment
    click_on('SAVE AND CONTINUE')
    click_on('PLACE ORDER')
    click_on('GO TO STORE')
    expect(current_path).to eq(root_path)
  end




  def fill_address
    address = FactoryGirl.attributes_for(:address)
    fill_in 'billing_address[first_name]', with:address[:first_name]
    fill_in 'billing_address[last_name]', with:address[:last_name]
    fill_in 'billing_address[address]', with:address[:address]
    fill_in 'billing_address[phone]', with:address[:phone]
    fill_in 'billing_address[city]', with:address[:city]
    fill_in 'billing_address[country]', with:address[:country]
    fill_in 'billing_address[zipcode]', with:address[:zipcode]

    fill_in 'shipping_address[first_name]', with:address[:first_name]
    fill_in 'shipping_address[last_name]', with:address[:last_name]
    fill_in 'shipping_address[address]', with:address[:address]
    fill_in 'shipping_address[phone]', with:address[:phone]
    fill_in 'shipping_address[city]', with:address[:city]
    fill_in 'shipping_address[country]', with:address[:country]
    fill_in 'shipping_address[zipcode]', with:address[:zipcode]
  end

  def fill_payment
    credit_card =  FactoryGirl.attributes_for(:credit_card)
    fill_in 'credit_card[number]', with:credit_card[:number]
    fill_in 'credit_card[cvv]', with:credit_card[:cvv]
    option_month = find(:xpath, "//*[@id='credit_card_exp_month']/option[2]").text
    option_year = find(:xpath, "//*[@id='credit_card_exp_year']/option[2]").text
    select(option_month, :from => 'credit_card_exp_month')
    select(option_year, :from => 'credit_card_exp_year')
  end

end