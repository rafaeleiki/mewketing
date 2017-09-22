class Email < ApplicationRecord
  belongs_to :sender
  belongs_to :receiver
  belongs_to :group
  has_many :email_receivers, :dependent => :delete_all
end
