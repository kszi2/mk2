json.id @free_day.public_id
json.extract! @free_day, :name, :from_day, :to_day, :created_at, :updated_at
json.url free_day_url(@free_day, format: :json)
