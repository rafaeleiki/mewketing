desc 'Checks if any email has to be sent'
task :send_scheduled_messages => :environment do
  puts "Checking email sent till #{Time.new}..."
  mm = MailManager.new
  emails = Email.should_send
  emails.each do |email|
    email.receivers.each do |receiver|
      mm.send_email(receiver.email, email.title, email.body)
      EmailReceiver.create({ email: email, receiver: receiver })
      puts "Sent from #{email.sender.email} to #{receiver.email}"
    end
  end
  emails.update_all(sent: true)
  puts "done."
end
