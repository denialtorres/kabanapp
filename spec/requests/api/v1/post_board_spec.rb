require "rails_helper"
require "swagger_helper"

RSpec.describe "POST /api/v1/boards", type: :request do
  path "/api/v1/boards" do
    post "Generates a new authenticated user's board" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :board, in: :body, require: true, description: "Board main data", schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ "name" ]
      }

      response "201", "Board created" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { { name: "test name" } }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          expect(body["data"]["attributes"]["name"]).to eq(board[:name])
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:Authorization) { "Bearer invalid_or_expired_token" }
        let(:board) { { name: "test name" } }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to be_present
        end
      end

      response "422", "Missing params" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { { name: "" } }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:unprocessable_entity)
          body = JSON.parse(response.body)
          expect(body["error"]["name"]).to eq([ "can't be blank" ])
        end
      end
    end
  end
end
