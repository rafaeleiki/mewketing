class Client < ApplicationRecord
  has_many :senders, :dependent => :delete_all

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
