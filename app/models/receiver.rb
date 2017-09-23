class Receiver < ApplicationRecord
  belongs_to :sender
  has_many :group_receivers
  has_many :groups, :through => :group_receivers
end
