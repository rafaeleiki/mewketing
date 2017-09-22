class EmailReceiver < ApplicationRecord
  belongs_to :email
  belongs_to :receiver
end
