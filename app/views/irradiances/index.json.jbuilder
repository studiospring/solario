json.array!(@irradiances) do |irradiance|
  json.extract! irradiance, :direct, :diffuse, :postcode_id
  json.url irradiance_url(irradiance, format: :json)
end
