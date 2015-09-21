FactoryGirl.define do
  factory :book do
    title       {Faker::Book.title}
    price       { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
    stock       { Faker::Number.between(10, 100) }
    author      {FactoryGirl.create(:author)}
    category    {FactoryGirl.create(:category)}
    image       Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test.jpg')))
  end

end
