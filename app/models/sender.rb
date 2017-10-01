class Sender < ApplicationRecord
  belongs_to :client
  has_many :groups
  has_many :emails
  has_secure_password

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}
  scope :admin, -> {where(admin: true)}
  scope :removable, -> {where(admin: false)}

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end

  def validate_new_password(old_password, new_password, confirm_password)
    if persisted?
      valid_password = authenticate(old_password)
      errors.add(:password, message: 'Invalid password') unless valid_password
    end

    errors.add(:password, message: 'Invalid password confirmation') if new_password != confirm_password
  end
end
