module Types
  class BoardType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :cards, [ Types::CardType ], null: false
  end
end
