class Receiver < ApplicationRecord
  include Activatable

  belongs_to :sender
  has_many :email_receiver, :dependent => :delete_all
  has_many :group_receivers
  has_many :groups, -> {active}, :through => :group_receivers
end
