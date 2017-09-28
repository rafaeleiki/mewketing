class Receiver < ApplicationRecord
  belongs_to :sender
  has_many :group_receiver, :dependent => :delete_all
  has_many :email_receiver, :dependent => :delete_all
  has_one :client, :through => :sender
end
