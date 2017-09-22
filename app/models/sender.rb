class Sender < ApplicationRecord
  belongs_to :client
  has_secure_password
end
