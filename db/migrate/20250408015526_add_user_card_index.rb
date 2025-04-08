class AddUserCardIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :user_cards, [ :user_id, :card_id ], unique: true, name: "index_user_cards_on_user_and_card"
  end
end
