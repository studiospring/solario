# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcode do
    pcode 1234
    suburb "Sunnyville"
    state "NSW"
    latitude -13
    longitude 123.123456
    urban false
  end

  factory :pv_output do
    system_watts 2345
    postcode 1234
    orientation 'N'
    tilt '23'
    shade 'No'
    total_output 54433
    efficiency 3.358
    entries 1000
    date_from '20101003'
    date_to '20140114'
    #significance 0
  end

  factory :pv_query do
    postcode
  end

  factory :panel do
    tilt 80
    bearing 180
    panel_size 3.5

    pv_query
  end

  factory :irradiance do
    direct "0.50 1.66 2.74 3.74 4.66 5.50 6.26 6.94 7.54 8.06 8.50 8.86 9.14 9.34 9.46 9.50 9.46 9.34 9.14 8.86 8.50 8.06 7.54 6.94 6.26 5.50 4.66 3.74 2.74 1.66 0.50 0 0 0 0 1.00 2.16 3.24 4.24 5.16 6.00 6.76 7.44 8.04 8.56 9.00 9.36 9.64 9.84 9.96 10.00 9.96 9.84 9.64 9.36 9.00 8.56 8.04 7.44 6.76 6.00 5.16 4.24 3.24 2.16 1.00 0 0 0 0 0.50 1.66 2.74 3.74 4.66 5.50 6.26 6.94 7.54 8.06 8.50 8.86 9.14 9.34 9.46 9.50 9.46 9.34 9.14 8.86 8.50 8.06 7.54 6.94 6.26 5.50 4.66 3.74 2.74 1.66 0.50 0 0 0 0 0 1.16 2.24 3.24 4.16 5.00 5.76 6.44 7.04 7.56 8.00 8.36 8.64 8.84 8.96 9.00 8.96 8.84 8.64 8.36 8.00 7.56 7.04 6.44 5.76 5.00 4.16 3.24 2.24 1.16 0 0 0 0 0 0 0.44 1.43 2.35 3.19 3.96 4.65 5.27 5.81 6.28 6.67 6.98 7.22 7.39 7.48 7.50 7.44 7.30 7.09 6.81 6.45 6.01 5.50 4.92 4.25 3.52 2.71 1.82 0.86 0 0 0 0 0 0 0 0.10 0.93 1.70 2.42 3.08 3.68 4.22 4.70 5.13 5.50 5.81 6.06 6.26 6.40 6.48 6.50 6.46 6.37 6.22 6.01 5.74 5.42 5.04 4.60 4.10 3.54 2.93 2.26 1.53 0.74 0 0 0 0 0 0 0 0.70 1.42 2.08 2.68 3.22 3.70 4.13 4.50 4.81 5.06 5.26 5.40 5.48 5.50 5.46 5.37 5.22 5.01 4.74 4.42 4.04 3.60 3.10 2.54 1.93 1.26 0.53 0 0 0 0 0 0 0 0 0 0.42 1.08 1.68 2.22 2.70 3.13 3.50 3.81 4.06 4.26 4.40 4.48 4.50 4.46 4.37 4.22 4.01 3.74 3.42 3.04 2.60 2.10 1.54 0.93 0.26 0 0 0 0 0 0 0 0 0 0.70 1.42 2.08 2.68 3.22 3.70 4.13 4.50 4.81 5.06 5.26 5.40 5.48 5.50 5.46 5.37 5.22 5.01 4.74 4.42 4.04 3.60 3.10 2.54 1.93 1.26 0.53 0 0 0 0 0 0 0.10 0.93 1.70 2.42 3.08 3.68 4.22 4.70 5.13 5.50 5.81 6.06 6.26 6.40 6.48 6.50 6.46 6.37 6.22 6.01 5.74 5.42 5.04 4.60 4.10 3.54 2.93 2.26 1.53 0.74 0 0 0 0 0 0.44 1.43 2.35 3.19 3.96 4.65 5.27 5.81 6.28 6.67 6.98 7.22 7.39 7.48 7.50 7.44 7.30 7.09 6.81 6.45 6.01 5.50 4.92 4.25 3.52 2.71 1.82 0.86 0 0 0 0 0 0 0 1.16 2.24 3.24 4.16 5.00 5.76 6.44 7.04 7.56 8.00 8.36 8.64 8.84 8.96 9.00 8.96 8.84 8.64 8.36 8.00 7.56 7.04 6.44 5.76 5.00 4.16 3.24 2.24 1.16 0 0 0 0 0"
    diffuse "2.4 4.8 9.6 4.8 2.4 2.2 4.4 8.8 4.4 2.2 2.1 4.2 8.4 4.2 2.1 1.8 3.6 7.2 3.6 1.8 1.5 3.0 6.0 3.0 1.5 1.4 2.8 5.6 2.8 1.4 1.5 3.0 6.0 3.0 1.5 1.8 3.6 7.2 3.6 1.8 2.2 4.4 8.8 4.4 2.2 2.4 4.8 9.6 4.8 2.4 2.6 5.2 10.4 5.2 2.6 2.5 5.0 10.0 5.0 2.5"
    
    postcode
  end

  factory :user do
    username 'Joe_user'
    email 'joe@example.com'
    password 'password'
    password_confirmation 'password'
    admin false

    factory :admin do
      admin true
    end
  end
end
