json.id @rating_style.public_id
json.name @rating_style.name

@rating_style.erb_source.open do |f|
  json.erb_source File.read f
end

json.url rating_style_url(@rating_style, format: :json)
