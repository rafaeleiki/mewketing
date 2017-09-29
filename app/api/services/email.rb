require 'net/smtp'

module Services
  class Email < Grape::API
    version 'v1', using: :header, vendor: 'email'
    content_type :json, 'application/json;charset=utf-8'

    resource :email do
      desc 'Sends an email'
      params do
        requires :content, type: String, desc: 'Content to be sent by email'
        requires :to, type: String, desc: 'Email address to be sent'
        requires :subject, type: String, desc: 'Email subject'
      end

      post :send do
        message = MailManager.new.send_email(params[:to], params[:subject], params[:content])
        { email: message.to_s }
      end

    end
  end
end
