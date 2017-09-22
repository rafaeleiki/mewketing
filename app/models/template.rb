class Template < ApplicationRecord
  belongs_to :sender
  validates :title, presence: true 
end
