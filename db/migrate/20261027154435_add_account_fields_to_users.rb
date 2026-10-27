class AddAccountFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string, null: false, default: "mechanic"

    add_reference :users, :mechanic, null: true, foreign_key: true, index: { unique: true }
    remove_index :users, :email_address

    add_index :users, "LOWER(email_address)", unique: true, name: "index_users_on_lower_email_address"
  end
end