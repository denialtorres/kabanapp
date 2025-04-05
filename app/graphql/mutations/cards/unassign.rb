module Mutations
  module Cards
    class Unassign < BaseMutation
      argument :card_id, ID, required: true
      argument :user_id, ID, required: true

      field :card, Types::CardType, null: false

      def resolve(card_id:, user_id:)
        card = Card.find(card_id)
        user = User.find(user_id)

        assigned_card = card.user_cards.find_by(user_id: user.id)

       { card: card } if assigned_card.destroy
      rescue StandardError => e
        raise GraphQL::ExecutionError, e.message
      end
    end
  end
end
