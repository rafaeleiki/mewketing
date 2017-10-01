class Sender < ApplicationRecord
  include Activatable

  belongs_to :client
  has_many :groups
  has_many :emails
  has_many :templates
  has_secure_password

  def validate_new_password(old_password, new_password, confirm_password)
    if persisted?
      valid_password = authenticate(old_password)
      errors.add(:password, message: 'Invalid password') unless valid_password
    end

    errors.add(:password, message: 'Invalid password confirmation') if new_password != confirm_password
  end
end
