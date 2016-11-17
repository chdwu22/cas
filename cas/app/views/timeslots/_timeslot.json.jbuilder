json.extract! timeslot, :id, :day, :from_time, :to_time, :created_at, :updated_at
json.url timeslot_url(timeslot, format: :json)