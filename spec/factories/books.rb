FactoryGirl.define do
  factory :book do
    title       {Faker::Book.title}
    price       { Faker::Commerce.price }
    description { Faker::Lorem.paragraph }
    stock       { Faker::Number.between(10, 100) }
    author
    category
    image       Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/test.jpg')))

    factory :book_with_rating do
      after(:create) do |book|
        FactoryGirl.create_list(:rating, 2, book: book)
      end
    end

  end

end
