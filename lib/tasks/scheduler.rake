desc 'Checks if any email has to be sent'
task :send_scheduled_messages => :environment do
  time = Time.new
  puts "Checking email sent till #{time}..."
  emails = Email.should_send

  emails.each do |email|
    email.send_email(time)
  end

  emails.update_all(sent: true)
  puts "done."
end
