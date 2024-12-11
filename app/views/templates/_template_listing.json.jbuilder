json.id template.public_id
json.extract! template, :name
json.url template_url(template, format: :json)
