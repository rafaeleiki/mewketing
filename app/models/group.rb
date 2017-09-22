class Group < ApplicationRecord
  belongs_to :sender
  has_many :group_receiver, :dependent => :delete_all
end
