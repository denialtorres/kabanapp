require "rails_helper"

RSpec.describe "GraphQL, unassignCard mutation", type: :request do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }
  let(:board) { create(:board, user: user) }

  let(:card) { create(:card, column: board.columns.first) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  before do
    card.user_cards.create(user: assignee)
  end

  let(:query) do
    <<~GRAPHQL
      mutation($cardId: ID!, $userId: ID!) {
        unassignCard(input: { cardId: $cardId, userId: $userId }) {
          card {
            id
            name
            description
            assignees {
              id
            }
          }
        }
      }
    GRAPHQL
  end

  it "unassigns the user from the card" do
    # validate that the assignee is assignated to this card
    expect(card.users).to include(assignee)

    post "/graphql", params: {
      query: query,
      variables: {
        cardId: card.id,
        userId: assignee.id
      }
    },
    headers: {
      Authorization: "Bearer #{devise_api_token.access_token}"
    }

    expect(response.parsed_body).not_to have_errors

    data = response.parsed_body["data"]["unassignCard"]["card"]
    expect(data["id"]).to eq(card.id.to_s)
    expect(data["assignees"].map { |a| a["id"] }).not_to include(assignee.id.to_s)

    # validate that the assignee is not assignated anymore
    expect(card.users).not_to include(assignee)
  end

  it "returns error if user is not assigned to the card" do
    # Try to unassign a user who is not assigned to the card
    unassigned_user = create(:user)

    post "/graphql", params: {
      query: query,
      variables: {
        cardId: card.id,
        userId: unassigned_user.id
      }
    },
    headers: {
      Authorization: "Bearer #{devise_api_token.access_token}"
    }

    expect(response.parsed_body).to have_key("errors")
    expect(response.parsed_body["errors"].first["message"]).to eq("undefined method `destroy' for nil")
  end
end
