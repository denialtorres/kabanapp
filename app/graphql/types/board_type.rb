module Types
  class BoardType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :cards, Types::CardType.connection_type, null: false, default_page_size: 10, max_page_size: 20
  end
end
