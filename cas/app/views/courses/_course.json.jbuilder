json.extract! course, :id, :number, :section, :name, :size, :day, :time, :year, :semester, :room_id, :user_id, :created_at, :updated_at
json.url course_url(course, format: :json)