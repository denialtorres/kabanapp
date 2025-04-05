require "rails_helper"

RSpec.describe "GraphQL, removeCard mutation", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let!(:column) { create(:column, board: board, position: "to_do") }
  let!(:card) { create(:card, column: column, name: "Original name", description: "Original description") }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  let(:query) do
    <<~QUERY
      mutation($id: ID!) {
        removeCard(input: { id: $id }) {
          id
        }
      }
    QUERY
  end

  it "removes the card successfully" do
    expect {
      post "/graphql", params: {
        query: query,
        variables: { id: card.id }
      },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }
    }.to change(Card, :count).by(-1)

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "removeCard" => { "id" => card.id.to_s }
    )
  end
end
