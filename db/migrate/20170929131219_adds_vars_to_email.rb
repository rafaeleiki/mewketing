class AddsVarsToEmail < ActiveRecord::Migration[5.1]
  def change
    add_column :emails, :vars, :jsonb, null: false, default: '{}'
  end
end
