require "rails_helper"
require "swagger_helper"

RSpec.describe "GET /api/v1/boards", type: :request do
  path "/api/v1/boards" do
    get "Retrieves the authenticated user's board" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"

      response "200", "Valid token - returns boards/project by the user" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let!(:boards) { create_list(:board, 5, user: user) }

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          expect(body["data"].size).to eq(user.boards.count)
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:Authorization) { "Bearer invalid_or_expired_token" }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to be_present
        end
      end
    end
  end
end
