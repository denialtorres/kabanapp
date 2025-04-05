require "rails_helper"

RSpec.describe "Graphql, boards query", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }

  it "retrieves a list of available boards" do
    query = <<~QUERY
      query {
        boards {
          id
          name
        }
      }
    QUERY

    post "/graphql", params: { query: query }
    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "boards" => [
        {
          "id" => board.id&.to_s,
          "name" => board.name
        }
      ]
    )
  end
end
