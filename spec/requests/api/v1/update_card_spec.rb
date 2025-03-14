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

      let(:user) { create(:user, role: "owner") }
      let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
      let(:board) { create(:board, user: user) }
      let!(:card_record) { create(:card, column: board.columns.first) }
      let(:board_id) { board.id }
      let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

      context "when the card exists" do
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

        response "200", "Card Updated" do
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
      end

      context "when an owner moves a card" do
        let(:id) { card_record.id }
        let(:card) do
          {
            card: {
              status: "done"
            }
          }
        end

        response "200", "Owner moves card successfully" do
          run_test! do
            expect(response).to have_http_status(:ok)
            card_record.reload
            expect(card_record.status).to eq("done")
          end
        end
      end

      context "when a regular user updates the card" do
        before do
          Card.all.each do |card|
            UserCard.create(card: card, user: regular_user)
          end
        end

        let(:regular_user) { create(:user) }
        let(:id) { card_record.id }

        let(:devise_api_token) { create(:devise_api_token, resource_owner: regular_user) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        context "when a regular user moves a card" do
          let(:card) do
            {
              card: {
                status: "in_progress"
              }
            }
          end

          response "200", "Card Is Moved" do
            run_test! do
              expect(response).to have_http_status(:ok)
              card_record.reload
              expect(card_record.status).to eq("in_progress")
            end
          end
        end

        context "when a regular user tries to edit a card content" do
          let(:card) do
            {
              card: {
                status: "in_progress",
                name: "new name"
              }
            }
          end

          response "403", "Forbidden error" do
            run_test! do
              expect(response).to have_http_status(:forbidden)
            end
          end
        end
      end

      context "when the card does not exist" do
        let(:id) { "non-existent-id" }
        let(:card) do
          {
            card: {
              name: "updated ticket",
              description: "this task is updated"
            }
          }
        end

        response "404", "Card not found" do
          run_test! do
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
