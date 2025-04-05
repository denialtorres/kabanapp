module Mutations
  module Cards
    class Assign < BaseMutation
      argument :card_id, ID, required: true
      argument :user_id, ID, required: true

      field :card, Types::CardType, null: false

      def resolve(card_id:, user_id:)
        card = Card.find(card_id)
        user = User.find(user_id)

        { card: card } if card.user_cards.create(user: user)
      rescue StandardError => e
        raise GraphQL::ExecutionError, e.message
      end
    end
  end
end
