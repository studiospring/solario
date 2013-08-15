# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcode do
    postcode 1
    suburb "MyString"
    state "MyString"
    latitude 1
    longitude 1
  end
end
