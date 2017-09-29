class AddsVarsToEmail < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :vars, :jsonb, default: '{}'
  end
end
