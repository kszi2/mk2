json.extract! @free_day, :id, :public_id, :name, :from_day, :to_day, :created_at, :updated_at
json.url free_day_url(@free_day, format: :json)
