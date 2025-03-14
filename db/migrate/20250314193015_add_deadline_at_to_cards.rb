class AddDeadlineAtToCards < ActiveRecord::Migration[8.0]
  def change
    add_column :cards, :deadline_at, :date
  end
end
