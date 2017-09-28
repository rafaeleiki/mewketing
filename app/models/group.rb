class Group < ApplicationRecord
  belongs_to :sender
  has_many :group_receivers
  has_many :receivers, -> {where(enabled: true)}, :through => :group_receivers

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
