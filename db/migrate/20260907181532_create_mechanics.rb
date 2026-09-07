class CreateMechanics < ActiveRecord::Migration[8.1]
  def change
    create_table :mechanics do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end