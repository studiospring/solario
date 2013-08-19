json.array!(@postcodes) do |postcode|
  json.extract! postcode, :pcode, :suburb, :state, :latitude, :longitude
  json.url postcode_url(postcode, format: :json)
end
