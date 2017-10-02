class Group < ApplicationRecord
  include Activatable

  belongs_to :sender
  has_many :group_receivers
  has_many :receivers, -> {active}, :through => :group_receivers

  accepts_nested_attributes_for :group_receivers, allow_destroy: true
end
