require "rails_helper"
require "swagger_helper"

RSpec.describe "PUT /api/v1/boards/:board_id/cards/:id", type: :request do
  path "/api/v1/boards/{board_id}/cards/{id}" do
    put "Updates an existing card on the board" do
      tags "Cards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true
      parameter name: :board_id, in: :path, type: :string, required: true, description: "Board ID"
      parameter name: :id, in: :path, type: :string, required: true, description: "Card ID"
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

      response "200", "Card Updated" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let(:card_record) { create(:card, column: board.columns.first) }
        let(:board_id) { board.id }
        let(:id) { card_record.id }

        let(:card) do
          {
            card: {
                    name: "updated ticket",
                    description: "this task is updated",
                    status: "in_progress"
                  }
          }
        end


        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          data = body["data"]

          expect(data).to include("id", "type", "attributes")
          expect(data["type"]).to eq("card")

          attributes = data["attributes"]
          expect(attributes).to include("id", "name", "description", "created_at", "updated_at", "position", "column")

          expect(attributes["name"]).to eq("updated ticket")
          expect(attributes["description"]).to eq("this task is updated")
          expect(attributes["column"]).to eq("in_progress")

          card_record.reload

          expect(card_record.status).to eq("in_progress")
        end
      end

      response "404", "Card not found" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let(:board_id) { board.id }
        let(:id) { "non-existent-id" }
        let(:card) { { name: "updated ticket", description: "this task is updated" } }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
