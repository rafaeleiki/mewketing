class Client < ApplicationRecord
  has_many :senders
  has_many :emails, :through => :senders
  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end
end
