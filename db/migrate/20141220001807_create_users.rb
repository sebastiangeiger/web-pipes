class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :provider_uid, null: false
      t.string :username, null: false

      t.timestamps null: false
    end
    add_index :users, :provider_uid, unique: true
  end
end
