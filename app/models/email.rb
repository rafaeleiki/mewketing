class Email < ApplicationRecord
  include BodyImageAttachable
  include Activatable

  belongs_to :sender
  has_many :email_groups
  has_many :groups, :through => :email_groups
  has_many :receivers, :through => :groups

  accepts_nested_attributes_for :email_groups, allow_destroy: true

  validates :title, presence: true

  # Custom validations
  validate :valid_vars

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
    text = body_without_images

    if vars.present? && vars != '{}'
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
      text = text.gsub("{{#{variable}}}", value)
    end
    text
  end

  def valid_vars
    if vars.present? && vars != '{}'
      if vars.key?('vars') && vars.key?('values')
        vars_values_validation
      else
        errors.add(:vars, "can't have invalid format; need keys 'vars' and 'values'")
      end
    end
  end

  def vars_values_validation
    valid = true
    if !vars['values'].empty?
      vars['vars'].each do |variable|
        var_found = false
        vars['values'].each do |data_line|
          var_found = data_line.key? variable
          break if var_found
        end
        valid = var_found
        break if !valid
      end
    end

    if !valid
      errors.add(:vars, 'has invalid values')
    end
  end
end
