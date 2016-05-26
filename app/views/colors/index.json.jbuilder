json.array!(@colors) do |color|
  json.extract! color, :id, :name, :color_code
  json.url color_url(color, format: :json)
end
