require 'net/smtp'

module Services
  class EmailAPI < Grape::API
    version 'v1', using: :header, vendor: 'email'
    content_type :json, 'application/json;charset=utf-8'

    helpers do
      def get_message(email_address, subject, content)
        options = { :address              => "smtp.gmail.com",
                    :port                 => 587,
                    :user_name            => ENV["email"],
                    :password             => ENV["email_password"],
                    :authentication       => :plain,
                    :domain               => 'localhost:3000',
                    :enable_starttls_auto => true  }

        mail = Mail.new do
          from    'marketing.mewtwo@gmail.com'
          to      email_address
          subject subject
          body    content
        end

        mail.delivery_method :smtp, options
        mail
      end
    end

    resource :email do
      desc 'Sends an email'
      params do
        requires :content, type: String, desc: 'Content to be sent by email'
        requires :to, type: String, desc: 'Email address to be sent'
        requires :subject, type: String, desc: 'Email subject'
      end

      post :send do
        message = get_message(params[:to], params[:subject], params[:content])
        message.deliver!
        { email: message.to_s }
      end

    end
  end
end
