class AddEnabledToAll < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :enabled, :boolean
    add_column :senders, :enabled, :boolean
    add_column :receivers, :enabled, :boolean
    add_column :groups, :enabled, :boolean
    add_column :templates, :enabled, :boolean
    add_column :emails, :enabled, :boolean
  end
end
