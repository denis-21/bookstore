FactoryGirl.define do
  factory :order_item do
    price "4.55"
    quantity 1
    book
    order
  end

end
