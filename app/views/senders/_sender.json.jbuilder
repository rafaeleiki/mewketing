json.extract! sender, :id, :email, :password_digest, :admin, :client_id, :created_at, :updated_at
json.url sender_url(sender, format: :json)
