class Group < ApplicationRecord
  belongs_to :sender
  has_many :group_receivers
  has_many :receivers, -> {active}, :through => :group_receivers

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  accepts_nested_attributes_for :group_receivers, allow_destroy: true

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end
end
