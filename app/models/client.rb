class Client < ApplicationRecord
  has_many :senders, :dependent => :delete_all
  has_many :emails, :through => :senders
end
