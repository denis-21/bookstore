FactoryGirl.define do
  factory :order do
    total_price Faker::Commerce.price
    state "in_progress"
    delivery
    user
    coupon nil

    factory :order_complete_date do
      completed_at Faker::Time.between(2.days.ago, Time.now, :all)
    end
  end

end
