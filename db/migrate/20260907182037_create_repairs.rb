class CreateRepairs < ActiveRecord::Migration[7.0]
  def change
    create_table :repairs do |t|
      t.bigint :bike_id, null: false
      t.bigint :mechanic_id 
      t.date :started_on
      t.date :promised_on, null: false
      t.datetime :handed_back_at
      t.string :state, default: "received", null: false
      t.timestamps
    end
  end
end