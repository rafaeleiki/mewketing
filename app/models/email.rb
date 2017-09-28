class Email < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
