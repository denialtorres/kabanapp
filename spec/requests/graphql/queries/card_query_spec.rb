require "rails_helper"

RSpec.describe "GraphQL, card query", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
  let!(:card) { create(:card, column: board.columns.first) }

  before do
    create(:user_card, user: user, card: card)
  end

  it "retrieves a specific card for the current user" do
    query = <<~GRAPHQL
      query($id: ID!) {
        card(id: $id) {
          id
          name
          description
        }
      }
    GRAPHQL

    post "/graphql", params: {
                     query: query,
                     variables: { id: card.id }
                   },
                   headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors

    expect(response.parsed_body["data"]).to eq(
      "card" => {
        "id" => card.id.to_s,
        "name" => card.name,
        "description" => card.description
      }
    )
  end
end
