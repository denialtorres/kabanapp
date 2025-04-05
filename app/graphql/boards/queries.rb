module Boards
  module Queries
    extend ActiveSupport::Concern

    included do
      field :boards, [ Types::BoardType ], null: false,
        description: "Retrieve a list of all boards that belong to the current user."

      field :board, Types::BoardType, null: false,
        description: "Fetch a specific board by its ID, belonging to the current user." do
          argument :id, GraphQL::Types::ID, required: true,
            description: "The unique identifier of the board."
      end
    end

    def boards
      context[:current_user]&.boards
    end

    def board(id:)
      context[:current_user]&.boards.find(id)
    end
  end
end
