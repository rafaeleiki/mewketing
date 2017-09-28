class Template < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true
  validates :title, uniqueness: true

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
