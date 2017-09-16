class CreateModules < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name

      t.timestamps
    end

    create_table :senders do |t|
      t.string :email
      t.string :password_digest
      t.boolean :admin
      t.references :client, foreign_key: true

      t.timestamps
    end

    create_table :receivers do |t|
      t.string :name
      t.string :email
      t.references :sender, foreign_key: true

      t.timestamps
    end

    create_table :groups do |t|
      t.string :name
      t.boolean :private
      t.references :sender, foreign_key: true

      t.timestamps
    end

    create_table :templates do |t|
      t.string :title
      t.string :body
      t.references :sender, foreign_key: true

      t.timestamps
    end

    create_table :emails do |t|
      t.datetime :schedule
      t.string :title
      t.string :body
      t.references :sender, foreign_key: true
      t.references :receiver, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
