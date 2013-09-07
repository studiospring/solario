# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcode do
    pcode 1234
    suburb "Sunnyville"
    state "NSW"
    latitude -13
    longitude 123.123456
  end

  factory :pv_query do
    postcode 2345
  end

  factory :panel do
    tilt 80
    bearing 180
    panel_size 3.5

    pv_query
  end

  factory :irradiance do
    direct "dummy"
    diffuse "dummy"
    
    postcode
  end

end
