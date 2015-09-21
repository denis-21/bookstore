FactoryGirl.define do
  factory :credit_card do
    number     {Faker::Number.number(16)}
    exp_month  "7"
    exp_year   "2021"
    cvv        {Faker::Number.number(3)}
  end

end
