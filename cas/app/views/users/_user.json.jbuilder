json.extract! user, :id, :first_name, :last_name, :full_name, :is_admin, :email, :password_digest, :created_at, :updated_at
json.url user_url(user, format: :json)