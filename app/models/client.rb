class Client < ApplicationRecord
  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
