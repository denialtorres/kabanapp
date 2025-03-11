class AddColumnsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :columns do |t|
      t.belongs_to :board, null: false, foreign_key: true
      t.integer :position
      t.string :name

      t.timestamps
    end
  end
end
