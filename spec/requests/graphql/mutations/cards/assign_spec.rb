require "rails_helper"

RSpec.describe "GraphQL, assignCard mutation", type: :request do
  let(:user) { create(:user) }
  let(:assignee) { create(:user) }
  let(:board) { create(:board, user: user) }

  let(:card) { create(:card, column: board.columns.first) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  let(:query) do
    <<~GRAPHQL
      mutation($cardId: ID!, $userId: ID!) {
        assignCard(input: { cardId: $cardId, userId: $userId }) {
          card {
            id
            name
            description
            assignees {
              id
              email
            }
          }
        }
      }
    GRAPHQL
  end

  it "assigns the user to the card" do
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

    data = response.parsed_body["data"]["assignCard"]["card"]
    expect(data["id"]).to eq(card.id.to_s)
    expect(data["assignees"].map { |a| a["id"] }).to include(assignee.id.to_s)
    expect(data["assignees"].map { |a| a["email"] }).to include(assignee.email)
  end

  it "returns error when user does not exist" do
    post "/graphql", params: {
      query: query,
      variables: {
        cardId: card.id,
        userId: "non-existent-user"
      }
    },
    headers: {
      Authorization: "Bearer #{devise_api_token.access_token}"
    }

    expect(response.parsed_body).to have_key("errors")
    expect(response.parsed_body["errors"].first["message"]).to eq("Couldn't find User with 'id'=non-existent-user")
  end
end
