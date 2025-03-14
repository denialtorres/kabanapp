require "rails_helper"
require "swagger_helper"

RSpec.describe "DELETE /api/v1/boards/:id", type: :request do
  path "/api/v1/boards/{id}" do
    delete "Deletes an existing board" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      let(:user) { create(:user, role: "owner") }
      let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
      let!(:board_record) { create(:board, user: user) }

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :id, in: :path, type: :string, required: true, description: "Board ID"

      response "204", "Board deleted" do
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:id) { board_record.id }

        run_test! do
          expect(response).to have_http_status(:success)
          expect(response.body).to be_empty
          expect(Board.count).to be_zero
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:Authorization) { "Bearer invalid_or_expired_token" }
        let(:board) { { name: "updated board name" } }
        let(:id) { board_record.id }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to be_present
        end
      end

      response "403", "Forbidden - Regular user cannot delete a board" do
        let(:regular_user) { create(:user, role: "user") }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: regular_user) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:id) { board_record.id }

        run_test! do
          expect(response).to have_http_status(:forbidden)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Access Denied")
        end
      end

      response "403", "Forbidden - Owner but not the creator of the board" do
        let(:other_owner) { create(:user, role: "owner") }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: other_owner) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:id) { board_record.id }

        run_test! do
          expect(response).to have_http_status(:forbidden)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("Access Denied")
        end
      end
    end
  end
end
