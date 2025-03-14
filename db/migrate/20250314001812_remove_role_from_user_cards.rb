class RemoveRoleFromUserCards < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_cards, :role, :string
  end
end