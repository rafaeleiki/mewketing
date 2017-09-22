class Receiver < ApplicationRecord
  belongs_to :sender
  has_many :email_receivers, :dependent => :delete_all
end
