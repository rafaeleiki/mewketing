class Email < ApplicationRecord
  belongs_to :sender
  has_many :email_groups
  has_many :groups, :through => :email_groups
  has_many :receivers, :through => :groups

  validates :title, presence: true

  scope :sent, -> { where(sent: true) }
  scope :not_sent, -> { where(sent: false) }
  scope :should_send, -> { not_sent.where('schedule <= ?', Time.new) }
end
