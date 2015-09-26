FactoryGirl.define do
  factory :order do
    total_price Faker::Commerce.price
    state "in_progress"
    delivery
    user
    coupon nil
  end

end
