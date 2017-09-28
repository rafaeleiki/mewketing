class CreateEmailReceivers < ActiveRecord::Migration[5.1]
  def change
    create_table :email_receivers do |t|
      t.references :receiver, foreign_key: true
      t.references :email, foreign_key: true
    end
  end
end
