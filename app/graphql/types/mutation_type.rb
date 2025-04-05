# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :add_board, mutation: Mutations::Boards::Add

    # for cards
    field :add_card, mutation: Mutations::Cards::Add
    field :update_card, mutation: Mutations::Cards::Update
  end
end
