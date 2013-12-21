json.array!(@pv_queries) do |pv_query|
  json.extract! pv_query, :postcode
  json.url pv_query_url(pv_query, format: :json)
end
