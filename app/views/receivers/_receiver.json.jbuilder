json.extract! receiver, :id, :name, :email, :sender_id, :created_at, :updated_at
json.url receiver_url(receiver, format: :json)
