FactoryGirl.define do
  factory :address do

    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    address    { Faker::Address.street_address }
    phone      "1234567890"
    city       { Faker::Address.city  }
    country    { Faker::Address.country }
    zipcode    "12345"

  end

end
