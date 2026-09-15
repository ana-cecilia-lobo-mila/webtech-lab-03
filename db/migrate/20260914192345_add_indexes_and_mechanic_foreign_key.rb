class AddIndexesAndMechanicForeignKey < ActiveRecord::Migration[8.1]
  def change
    add_index :bikes, :customer_id
    add_index :repairs, :bike_id
    add_index :repairs, :mechanic_id
    add_index :repair_services, :repair_id
    add_index :repair_services, :service_id

    add_foreign_key :repairs, :mechanics
  end
end