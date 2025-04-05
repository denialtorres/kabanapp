module Mutations
  module Cards
    class Add < BaseMutation
      graphql_name "addCard"

      type Types::CardType, null: false

      argument :board_id, ID, required: true
      argument :name, String, required: true
      argument :description, String, required: true
      argument :status, Types::CardStatusType, required: true

      def resolve(board_id:, name:, description:, status:)
        board = Board.find(board_id)
        column = find_column(board, status)

        column.cards.create!(name: name, description: description)
      end

      private

      def find_column(board, status)
        board.columns.find_by(position: status) ||
          board.columns.find_by(position: "to_do") ||
          raise(ActiveRecord::RecordNotFound, "No column found for status '#{status}' or default 'to_do'")
      end
    end
  end
end
