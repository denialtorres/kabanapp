require "rails_helper"
require "swagger_helper"

RSpec.describe "GET /api/v1/boards/:id", type: :request do
  path "/api/v1/boards/{id}" do
    get "Retrieves the authenticated user specific board by id" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :id, in: :path, type: :string, required: true, description: "Board ID"

      response "200", "Valid token - returns specific board" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let(:id) { board.id }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          expect(body["data"]["id"]).to eq(board.id.to_s)
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:Authorization) { "Bearer invalid_or_expired_token" }
        let(:id) { 1 }
        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to be_present
        end
      end

      response "404", "Board not found" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        let(:id) { "999999" }

        run_test! do
          expect(response).to have_http_status(:not_found)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Board not found")
        end
      end
    end
  end
end
