module Mutations
  module Cards
    class Update < BaseMutation
      type Types::CardType, null: false

      argument :id, ID, required: true, description: "Card ID"
      argument :name, String, required: false
      argument :description, String, required: false
      argument :status, Types::CardStatusType, required: false

      def resolve(id:, name: nil, description: nil, status: nil)
        card = Card.find(id)

        attributes = {
          name: name.presence,
          description: description.presence
        }.compact

        if status.present?
          board = card.column.board
          column = board.columns.find_by(position: status.downcase)
          raise GraphQL::ExecutionError, "Invalid status: #{status}" unless column

          card.column = column
        end

        card.update!(attributes)
        card
      end
    end
  end
end
