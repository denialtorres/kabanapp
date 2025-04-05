# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_board, mutation: Mutations::Boards::Add
  end
end
