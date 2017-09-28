class Group < ApplicationRecord
  belongs_to :sender
  has_many :receivers, :through => :group_receivers
  has_many :group_receivers, :dependent => :delete_all

  accepts_nested_attributes_for :group_receivers, allow_destroy: true
end
