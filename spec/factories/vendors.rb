FactoryBot.define do
  factory :vendor do
    name { Faker::Commerce.vendor }
    description { Faker::Commerce.product_name }
    contact_name { Faker::Name.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end