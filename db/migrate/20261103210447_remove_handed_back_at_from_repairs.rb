class RemoveHandedBackAtFromRepairs < ActiveRecord::Migration[8.1]
  def change
    remove_column :repairs, :handed_back_at, :datetime
  end
end
