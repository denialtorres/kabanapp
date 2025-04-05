module Cards
  module Queries
    extend ActiveSupport::Concern

    included do
      field :cards, Types::CardType.connection_type, null: false, default_page_size: 10, max_page_size: 20,
        description: "Retrieve a list of all cards that belong to the current user."

      field :card, Types::CardType, null: false,
        description: "Fetch a specific card by its ID, belonging to the current user." do
          argument :id, GraphQL::Types::ID, required: true,
            description: "The unique identifier of the board."
      end
    end

    def cards
      context[:current_user]&.cards
    end

    def card(id:)
      context[:current_user]&.cards.find(id)
    end
  end
end
