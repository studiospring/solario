json.array!(@panels) do |panel|
  json.extract! panel, :tilt, :bearing, :panel_size
  json.url panel_url(panel, format: :json)
end
