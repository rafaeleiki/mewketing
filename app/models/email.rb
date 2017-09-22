class Email < ApplicationRecord
  belongs_to :sender
  belongs_to :receiver
  belongs_to :group
end
