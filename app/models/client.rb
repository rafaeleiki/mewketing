class Client < ApplicationRecord
  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end
end
