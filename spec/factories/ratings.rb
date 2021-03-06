FactoryGirl.define do
  factory :rating do
    review { Faker::Lorem.sentence }
    rating { Faker::Number.between(1, 5) }
    book
    user
    status false

    factory :approved_rating do
      status true
    end

  end


end
