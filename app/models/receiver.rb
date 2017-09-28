class Receiver < ApplicationRecord
  belongs_to :sender
  has_many :groups, :through => :group_receivers
  has_many :group_receivers, :dependent => :delete_all

  # Include the management of the enabled flag
  def destroy
    self.enabled = false
    save
  end
end
