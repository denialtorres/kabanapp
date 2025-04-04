require "rails_helper"
require "swagger_helper"

RSpec.describe "POST /api/v1/boards/:board_id/cards/:id/unassign", type: :request do
  path "/api/v1/boards/{board_id}/cards/{id}/unassign" do
    post "Unassigns a user from an existing card" do
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
                        user_id: { type: :string }
                      },
                      required: [ "user_id" ]
                    }
                  }
                }

      response "200", "User Unassigned" do
        let(:user) { create(:user, role: "owner") }
        let(:regular_user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let!(:card_record) { create(:card, column: board.columns.first) }
        let(:board_id) { board.id }
        let(:id) { card_record.id }

        let(:card) do
          {
            card: {
              user_id: regular_user.id
            }
          }
        end

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        before do
          card_record.user_cards.create(user: regular_user)

          expect(card_record.user_cards.pluck(:user_id)).to include(regular_user.id)
        end

        run_test! do
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          data = body["data"]
          attributes = data["attributes"]

          expect(attributes).to include("assigned_users")
          expect(attributes["assigned_users"]).to be_empty
          expect(card_record.user_cards.size).to be_zero
        end
      end

      response "403", "Forbidden - Regular user cannot unassign" do
        let(:regular_user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: regular_user) }
        let(:board) { create(:board, user: create(:user, role: "owner")) } # Owner is a different user
        let!(:card_record) { create(:card, column: board.columns.first) }
        let(:board_id) { board.id }
        let(:id) { card_record.id }

        let(:card) do
          {
            card: {
              user_id: regular_user.id
            }
          }
        end

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        before do
          card_record.user_cards.create(user: regular_user)
        end

        run_test! do
          expect(response).to have_http_status(:forbidden)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Access Denied")
        end
      end
    end
  end
end
