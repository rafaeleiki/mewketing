class EmailGroups < ActiveRecord::Migration[5.1]
  def change
      create_table :email_groups do |t|
          t.references :email, foreign_key: true
          t.references :group, foreign_key: true
      end

      remove_column :emails, :receiver_id
      remove_column :emails, :group_id
  end

end
