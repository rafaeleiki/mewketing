class Email < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
