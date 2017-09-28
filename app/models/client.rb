class Client < ApplicationRecord
  has_many :senders
  has_many :groups, :through => :senders
  has_many :emails, :through => :senders
  has_many :templates, :through => :senders
  has_many :receivers, :through => :senders
end
