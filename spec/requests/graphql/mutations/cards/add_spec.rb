require "rails_helper"

RSpec.describe "GrapQL, addCard mutation", type: :request do
  let(:user) { create(:user) }
  let!(:board) { create(:board, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  let(:query) do
    <<-QUERY
      mutation($id: ID!, $name: String!, $description: String!, $status: CardStatus!){
        addCard(input: { boardId: $id, name: $name, description: $description,  status: $status }){
          id
          name
          description
          status
        }
      }
    QUERY
  end

  it "add a new card" do
    post "/graphql", params: {
      query: query,
      variables: {
        id: board.id,
        name: "new card from graphql",
        description: "new description from graphql",
        status: "TO_DO"
      }
     },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]).to eq(
      "addCard" => {
        "id" => Card.last.id.to_s,
        "name" => "new card from graphql",
        "description" => "new description from graphql",
        "status" => "to_do"
      }
    )
  end

  it "returns an error when status is invalid" do
    post "/graphql", params: {
      query: query,
      variables: {
        id: board.id,
        name: "invalid status card",
        description: "some description",
        status: "INVALID_STATUS"
      }
     },
      headers: {
        Authorization: "Bearer #{devise_api_token.access_token}"
      }

    expect(response.parsed_body["errors"]).to be_present

    expect(response.parsed_body["errors"].first["message"]).to match(
      /Variable \$status of type CardStatus! was provided invalid value/i
    )
  end
end
