json.array!(@sizes) do |size|
  json.extract! size, :id, :size
  json.url size_url(size, format: :json)
end
