class CreateGroupReceivers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_receivers do |t|
      t.references :groups, foreign_key: true
      t.references :receivers, foreign_key: true
    end
  end
end
