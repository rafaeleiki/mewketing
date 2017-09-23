class Client < ApplicationRecord
  has_many :senders, :dependent => :delete_all
end
