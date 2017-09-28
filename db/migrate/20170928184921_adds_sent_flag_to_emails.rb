class AddsSentFlagToEmails < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :sent, :boolean
  end
end
