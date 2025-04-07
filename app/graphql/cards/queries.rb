module Cards
  module Queries
    extend ActiveSupport::Concern

    included do
      field :cards, Types::CardType.connection_type, null: false, default_page_size: 10, max_page_size: 20,
        description: "Retrieve a list of all cards that belong to the current user." do
          argument :query, String, required: false, description: "find specific cards by name or description"
          argument :status, Types::CardStatusType, required: false, description: "filter by status of the card to_do, in_progress, done"
        end

      field :card, Types::CardType, null: false,
        description: "Fetch a specific card by its ID, belonging to the current user." do
          argument :id, GraphQL::Types::ID, required: true,
            description: "The unique identifier of the board."
      end
    end

    def cards(query: nil, status: nil)
      params = {
        query: query,
        status: status
    }

      payload = MyCardsOrganizer.call(user: context[:current_user], params: HashWithIndifferentAccess.new(params))

      payload.cards
    end

    def card(id:)
      context[:current_user]&.cards.find(id)
    end
  end
end
