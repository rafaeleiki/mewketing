class CreateGroupReceivers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_receivers do |t|
      t.references :group, foreign_key: true
      t.references :receiver, foreign_key: true
    end
  end
end
