require "rails_helper"
require "swagger_helper"

RSpec.describe "PUT /api/v1/boards/:id", type: :request do
  path "/api/v1/boards/{id}" do
    put "Updates an existing board" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      let(:user) { create(:user, role: "owner") }

      let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :id, in: :path, type: :string, required: true, description: "Board ID"
      parameter name: :board, in: :body, require: true, description: "Board main data", schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ "name" ]
      }

      before(:each) do
        create(:board, user: user)
      end

      response "200", "Board updated" do
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:board) { { name: "updated board name" } }
        let(:id) { Board.last.id }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          expect(body["data"]["attributes"]["name"]).to eq(board[:name])
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:Authorization) { "Bearer invalid_or_expired_token" }
        let(:board) { { name: "updated board name" } }
        let(:id) { 1 }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to be_present
        end
      end

      response "422", "Missing params" do
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:board) { { name: "" } }
        let(:id) { Board.last.id }

        run_test! do
          expect(response).to have_http_status(:unprocessable_entity)
          body = JSON.parse(response.body)
          expect(body["error"]["name"]).to eq([ "can't be blank" ])
        end
      end

      response "403", "Forbidden - Regular user cannot update the board" do
        let(:regular_user) { create(:user) } # Default role should be "user"
        let(:devise_api_token) { create(:devise_api_token, resource_owner: regular_user) }
        let(:board) { { name: "Updated by regular user" } }

        let(:id) { Board.last.id }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:forbidden)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Access Denied")
        end
      end
    end
  end
end
