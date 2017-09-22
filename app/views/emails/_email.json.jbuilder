json.extract! email, :id, :schedule, :title, :body, :sender_id, :receiver_id, :group_id, :created_at, :updated_at
json.url email_url(email, format: :json)
