module Boards
  module Queries
    extend ActiveSupport::Concern

    included do
      field :boards, [ Types::BoardType ], null: false
      field :board, Types::BoardType, null: false do
        argument :id, GraphQL::Types::ID, required: true
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
