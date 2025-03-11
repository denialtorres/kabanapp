class AddCardsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :cards do |t|
      t.belongs_to :column, null: false, foreign_key: true
      t.integer :position
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
