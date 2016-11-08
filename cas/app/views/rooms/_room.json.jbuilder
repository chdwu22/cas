json.extract! room, :id, :number, :capacity, :building_id, :created_at, :updated_at
json.url room_url(room, format: :json)