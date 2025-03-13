require "rails_helper"
require "swagger_helper"

RSpec.describe "POST /api/v1/boards/:id/cards", type: :request do
  path "/api/v1/boards/{board_id}/cards" do
    post "Generates a new card for the board" do
      tags "Cards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :board_id, in: :path, type: :string, required: true, description: "Board ID"
      parameter name: :card, in: :body, required: true, description: "Updated card data",
                schema: {
                  type: :object,
                  properties: {
                    card: {
                      type: :object,
                      properties: {
                        name: { type: :string },
                        description: { type: :string },
                        status: { type: :string, enum: [ "to_do", "in_progress", "done" ] }
                      },
                      required: [ "name", "description" ]
                    }
                  }
                }

      response "201", "Card Created" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let(:board_id) { board.id }
        let(:card) do
          {
            card: {
                    name: "first ticket",
                    description: "this is your first task"
                  }
          }
        end

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          data = body["data"]

          expect(data).to include("id", "type", "attributes")
          expect(data["type"]).to eq("card")

          attributes = data["attributes"]
          expect(attributes).to include("id", "name", "description", "created_at", "updated_at", "position", "column")


          expect(attributes["name"]).to eq("first ticket")
          expect(attributes["description"]).to eq("this is your first task")
          expect(attributes["column"]).to eq("to_do")
        end
      end
    end
  end
end
