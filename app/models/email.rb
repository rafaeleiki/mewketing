class Email < ApplicationRecord
  belongs_to :sender
  has_many :email_groups
  has_many :groups, :through => :email_groups
  has_many :receivers, :through => :groups

  validates :title, presence: true

  scope :sent, -> { where(sent: true) }
  scope :not_sent, -> { where(sent: false) }
  scope :should_send, -> { not_sent.where('schedule <= ?', Time.new) }

  def send_email(time = Time.new)
    mm = MailManager.new
    self.receivers.each do |receiver|
      mm.send_email(receiver.email, title, body_with_vars(receiver.email))
      EmailReceiver.create({ email_id: self.id, receiver: receiver })
      puts "Email sent from #{sender.email} to #{receiver.email} at #{time}"
    end
  end

  def body_with_vars(email)
    text = body
    if vars.present?
      vars['values'].each do |data|
        if data['email'] == email
          text = replace_vars(data)
          break
        end
      end
    end
    text
  end

  private

  def replace_vars(data)
    text = body
    data.each_pair do |variable, value|
      text.gsub!("{{#{variable}}}", value)
    end
    text
  end
end
