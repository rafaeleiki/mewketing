class Email < ApplicationRecord
  belongs_to :sender
  has_many :email_groups
  has_many :groups, :through => :email_groups
  has_many :receivers, :through => :groups

  accepts_nested_attributes_for :email_groups, allow_destroy: true

  validates :title, presence: true

  # Scopes
  scope :active, -> {where(enabled: true)}
  scope :inactive, -> {where(enabled: false)}

  # Include the management of the enabled flag
  def destroy
    update(enabled: false)
  end

  scope :sent, -> { where(sent: true) }
  scope :not_sent, -> { where(sent: false) }
  scope :should_send, -> { not_sent.where('schedule <= ?', Time.new) }

  def send_email(time = Time.new)
    mm = MailManager.new
    self.receivers.each do |receiver|
      mm.send_email(receiver.email, title, body)
      EmailReceiver.create({ email_id: self.id, receiver: receiver })
      puts "Email sent from #{sender.email} to #{receiver.email} at #{time}"
    end
  end
end
