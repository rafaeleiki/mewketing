class Client < ApplicationRecord
  has_many :senders, :dependent => :delete_all
  has_many :emails, :through => :senders
  has_many :templates, :through => :senders
end
