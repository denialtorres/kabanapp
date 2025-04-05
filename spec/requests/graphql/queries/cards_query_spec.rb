require "rails_helper"

RSpec.describe "GraphQL, cards query", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
  let!(:cards) do
    create_list(:card, 15, column: board.columns.first)
  end

  before do
    cards.each { |card| create(:user_card, user: user, card: card) }
  end

  it "retrieves all cards for the current user" do
    query = <<~GRAPHQL
      query {
        cards {
          nodes {
            name
            description
            status
          }
          pageInfo{
            endCursor
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors

    cards_data = response.parsed_body["data"]["cards"]

    expect(cards_data["nodes"]).to match_array(
      cards.first(10).map do |card|
        {
          "name" => card.name,
          "description" => card.description,
          "status" => card.status
        }
      end
    )

    expect(cards_data["pageInfo"]).to include("endCursor")
  end

  it "respects the max_page_size limit" do
    query = <<~GRAPHQL
      query {
        cards(first: 20) {
          nodes{
            name
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]["cards"]["nodes"].size).to eq(15)
  end
end
