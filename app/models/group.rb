class Group < ApplicationRecord
  belongs_to :sender
  has_many :group_receivers
  has_many :receivers, :through => :group_receivers
end
