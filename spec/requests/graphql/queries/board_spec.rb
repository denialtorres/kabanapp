require "rails_helper"

RSpec.describe "Graphql, board query", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
  let!(:cards) do
    create_list(:card, 15, column: board.columns.first)
  end

  before do
    cards.each { |card| create(:user_card, user: user, card: card) }
  end


  it "retrieves an specific board" do
    query = <<~QUERY
      query ($id: ID!) {
        board(id: $id) {
          id
          name
        }
      }
    QUERY

    post "/graphql", params: {
                     query: query,
                     variables: { id: board.id }
                    },
                     headers:  {
                      Authorization: "Bearer #{devise_api_token.access_token}"
                    }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "board" =>
        {
          "id" => board.id&.to_s,
          "name" => board.name
        }
    )
  end

  it "retrieves an specific board with cards" do
    query = <<~QUERY
      query ($id: ID!) {
        board(id: $id) {
          id
          name
          cards {
            name
            description
          }
        }
      }
    QUERY

    post "/graphql", params: {
                     query: query,
                     variables: { id: board.id }
                    },
                     headers:  {
                      Authorization: "Bearer #{devise_api_token.access_token}"
                    }

    expect(response.parsed_body).not_to have_errors

    expect(response.parsed_body["data"]).to eq(
      "board" => {
        "id" => board.id.to_s,
        "name" => board.name,
        "cards" => cards.map do |card|
          {
            "name" => card.name,
            "description" => card.description
          }
        end
      }
    )
  end

  it "retrieves a specific board with cards and their assignees" do
    query = <<~QUERY
      query ($id: ID!) {
        board(id: $id) {
          id
          name
          cards {
            name
            description
            assignees {
              id
              email
            }
          }
        }
      }
    QUERY

    post "/graphql", params: {
                     query: query,
                     variables: { id: board.id }
                    },
                     headers: {
                      Authorization: "Bearer #{devise_api_token.access_token}"
                    }

    expect(response.parsed_body).not_to have_errors

    expect(response.parsed_body["data"]).to eq(
      "board" => {
        "id" => board.id.to_s,
        "name" => board.name,
        "cards" => cards.map do |card|
          {
            "name" => card.name,
            "description" => card.description,
            "assignees" => [
              {
                "id" => user.id.to_s,
                "email" => user.email
              }
            ]
          }
        end
      }
    )
  end
end
