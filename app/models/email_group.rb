class EmailGroup < ApplicationRecord
  belongs_to :email
  belongs_to :group
end