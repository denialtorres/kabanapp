class RemovePositionFromCards < ActiveRecord::Migration[8.0]
  def change
    remove_column :cards, :position, :integer
  end
end
