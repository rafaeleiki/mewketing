class AddEnabledToAll < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :enabled, :boolean, :default => true
    add_column :senders, :enabled, :boolean, :default => true
    add_column :receivers, :enabled, :boolean, :default => true
    add_column :groups, :enabled, :boolean, :default => true
    add_column :emails, :enabled, :boolean, :default => true
  end
end
