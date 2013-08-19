# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcode do
    pcode 1234
    suburb "Sunnyville"
    state "NSW"
    latitude 3
    longitude 123.123456
  end
end
