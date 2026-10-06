class AddNotNullConstraintsToBikesAndCustomers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :bikes, :brand, false
    change_column_null :bikes, :model, false
    change_column_null :bikes, :color, false
    change_column_null :bikes, :serial_number, false

    change_column_null :customers, :phone, false
  end
end