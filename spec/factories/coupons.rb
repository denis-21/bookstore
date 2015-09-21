FactoryGirl.define do
  factory :coupon do
    name       "super"
    discount   "20"
    expires_at {Faker::Date.forward(23)}
  end

end
