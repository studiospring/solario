json.array!(@postcodes) do |postcode|
  json.extract! postcode, :postcode, :suburb, :state, :latitude, :longitude
  json.url postcode_url(postcode, format: :json)
end
