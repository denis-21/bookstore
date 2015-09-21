FactoryGirl.define do
  factory :delivery do
    name {Faker::Name.title}
    price { Faker::Commerce.price }
  end

end
