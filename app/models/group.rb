class Group < ApplicationRecord
  belongs_to :sender
  has_many :receivers, :through => :group_receivers

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
