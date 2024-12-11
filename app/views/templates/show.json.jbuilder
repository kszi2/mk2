json.id @template.public_id
json.extract! @template, :name, :data
json.url template_url(@template, :json)
