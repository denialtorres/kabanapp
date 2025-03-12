require "rails_helper"
require "swagger_helper"

RSpec.describe "DELETE /api/v1/boards/:id", type: :request do
  path "/api/v1/boards/{id}" do
    delete "Deletes an existing board" do
      tags "Boards"
      consumes "application/json"
      produces "application/json"

      let(:user) { create(:user) }
      let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :id, in: :path, type: :string, required: true, description: "Board ID"

      before(:each) do
        create(:board, user: user)
      end

      response "204", "Board deleted" do
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }
        let(:id) { Board.last.id }

        run_test! do
          expect(response).to have_http_status(:success)
          expect(response.body).to be_empty
          expect(Board.count).to be_zero
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
    end
  end
end