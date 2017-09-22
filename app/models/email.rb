class Email < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true
  has_many :email_receiver, :dependent => :delete_all
end
