class GroupReceiver < ApplicationRecord
  belongs_to :group
  belongs_to :receiver

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
