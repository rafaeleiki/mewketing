class Sender < ApplicationRecord
  belongs_to :client
  has_many :groups
  has_secure_password

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
