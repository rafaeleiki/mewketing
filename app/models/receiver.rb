class Receiver < ApplicationRecord
  belongs_to :sender
  has_many :email_receiver, :dependent => :delete_all
  has_one :client, :through => :sender
  has_many :group_receivers
  has_many :groups, -> {active}, :through => :group_receivers

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: fale)}

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end
end
