require "rails_helper"

RSpec.describe "GrapQL, updateCard mutation", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let!(:column) { create(:column, board: board, position: "to_do") }
  let!(:card) { create(:card, column: column, name: "Original name", description: "Original description") }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  let(:query) do
    <<~QUERY
      mutation($id: ID!, $name: String, $description: String, $status: CardStatus) {
        updateCard(input: { id: $id, name: $name, description: $description, status: $status }) {
          id
          name
          description
          status
        }
      }
    QUERY
  end

  it "updates the card name and description" do
    post "/graphql", params: {
      query: query,
      variables: {
        id: card.id,
        name: "Updated card from graphql",
        description: "Updated description from graphql"
      }
     },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "updateCard" => {
        "id" => card.id.to_s,
        "name" => "Updated card from graphql",
        "description" => "Updated description from graphql",
        "status" => "to_do"
      }
    )
  end

  it "updates the card status" do
    post "/graphql", params: {
      query: query,
      variables: {
        id: card.id,
        status: "IN_PROGRESS"
      }
     },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]["updateCard"]).to include(
      "id" => card.id.to_s,
      "name" => "Original name",
      "description" => "Original description",
      "status" => "in_progress"
    )
  end

  it "returns an error when status is invalid" do
    post "/graphql", params: {
      query: query,
      variables: {
        id: card.id,
        status: "INVALID_STATUS"
      }
    },
    headers: {
      Authorization: "Bearer #{devise_api_token.access_token}"
    }

    expect(response.parsed_body).to have_key("errors")
    expect(response.parsed_body["errors"].first["message"]).to include(
      'Variable $status of type CardStatus was provided invalid value'
    )
  end
end
