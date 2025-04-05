module Mutations
  module Cards
    class Remove < BaseMutation
      argument :id, ID, required: true

      field :id, ID, null: false

      def resolve(id:)
        card = Card.find(id)
        card.destroy!

        { id: card.id }
      end
    end
  end
end
