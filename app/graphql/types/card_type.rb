module Types
  class CardType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :description, String, null: false
    field :assignees, [ Types::UserType ], null: false, description: "Users assigned to this card"

    def assignees
      object.users
    end
  end
end
