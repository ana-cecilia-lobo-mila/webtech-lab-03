class CreateBikes < ActiveRecord::Migration[8.1]
  def change
    create_table :bikes do |t|
      t.bigint :customer_id, null: false 
      t.string :brand
      t.string :model
      t.string :color
      t.string :serial_number
      t.timestamps
    end
    add_index :bikes, :serial_number, unique: true
  end
end