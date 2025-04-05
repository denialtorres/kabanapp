require "rails_helper"

RSpec.describe "GrapQL, addBoard mutation", type: :request do
  let!(:user) { create(:user, role: "owner") }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  let(:query) do
    <<-QUERY
      mutation($name: String!){
        addBoard(input: { name: $name }){
          id
          name
        }
      }
    QUERY
  end

  it "add a new board" do
    post "/graphql", params: {
      query: query,
      variables: { name: "new board from graphql" }
     },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "addBoard" => {
        "id" => Board.last.id.to_s,
        "name" => "new board from graphql"
      }
    )
  end
end
