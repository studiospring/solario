# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcode do
    postcode 1234
    suburb "Sunnyville"
    state "NSW"
    latitude 123.123456
    longitude 123.123456
  end
end
