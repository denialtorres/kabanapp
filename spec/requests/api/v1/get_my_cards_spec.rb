require "rails_helper"
require "swagger_helper"

RSpec.describe "GET /api/v1/cards/my_cards", type: :request do
  path "/api/v1/cards/my_cards" do
    get "Retrieves the authenticated user's assigned cards" do
      tags "Cards"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"
      parameter name: :page_token, in: :query, type: :string, required: false, description: "Pagination token for retrieving the next or previous page"

      response "200", "Valid token - returns assigned cards" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:board) { create(:board, user: user) }
        let(:column) { create(:column, board: board) }
        let!(:cards) { create_list(:card, 15, column: column) } # Create more than the page limit to test pagination

        before do
          cards.each { |card| create(:user_card, user: user, card: card) }
        end

        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)

          expect(body["data"]["attributes"]["page_info"]).to include("page_records", "next_page_token", "previous_page_token")

          expect(body["data"]["attributes"]["cards"].size).to be <= 10 # Should not exceed the page limit

          if body["data"]["attributes"]["page_info"]["next_page_token"].present?
            next_page_token = body["data"]["attributes"]["page_info"]["next_page_token"]

            get "/api/v1/cards/my_cards", headers: { "Authorization" => "Bearer #{devise_api_token.access_token}" }, params: { page_token: next_page_token }

            expect(response).to have_http_status(:success)
            next_body = JSON.parse(response.body)

            expect(next_body["data"]["attributes"]["cards"]).not_to be_empty
            expect(next_body["data"]["attributes"]["page_info"]["previous_page_token"]).to be_present
          end
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
