FactoryGirl.define do
  factory :user do
    email {Faker::Internet.email}
    password '123456'
    password_confirmation '123456'
    admin false

    factory :admin do
      admin true
    end
    factory :facebook_user do
      provider 'facebook'
      uid { Faker::Number.number(7) }
    end

  end

end
