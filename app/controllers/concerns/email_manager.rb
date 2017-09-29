module EmailManager
  extend ActiveSupport::Concern

  def send_email(email_address, subject, content)
    options = { :address              => "smtp.gmail.com",
                :port                 => 587,
                :user_name            => ENV["email"],
                :password             => ENV["email_password"],
                :authentication       => :plain,
                :domain               => 'localhost:3000',
                :enable_starttls_auto => true  }

    message = Mail.new do
      from    'marketing.mewtwo@gmail.com'
      to      email_address
      subject subject
      body    content
    end

    message.delivery_method :smtp, options
    message.deliver!
    message
  end
end
