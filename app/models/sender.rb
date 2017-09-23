class Sender < ApplicationRecord
  belongs_to :client
  has_many :groups
  has_secure_password
end
