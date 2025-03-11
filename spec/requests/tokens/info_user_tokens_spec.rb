require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Info Token', type: :request do
  path "/users/tokens/info" do
    get "Retrieves the authenticated user's information" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :Authorization, in: :header, type: :string, required: true, description: "Bearer token"

      response "200", "Valid token - returns user info" do
        let(:user) { create(:user) }
        let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:success)
          body = JSON.parse(response.body)
          expect(body["id"]).to eq(user.id)
          expect(body["email"]).to eq(user.email)
          expect(body["created_at"].to_date).to eq(user.created_at.to_date)
          expect(body["updated_at"].to_date).to eq(user.updated_at.to_date)
        end
      end

      response "401", "Invalid token - unauthorized" do
        let(:user) { create(:user) }
        let(:devise_api_token) { build(:devise_api_token, resource_owner: user) }
        let(:Authorization) { "Bearer #{devise_api_token.access_token}" }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          body = JSON.parse(response.body)
          expect(body["error"]).to eq("invalid_token")
          expect(body["error_description"]).to eq(["Invalid token"])
          expect(body["id"]).to be_nil
          expect(body["email"]).to be_nil
          expect(body["created_at"]).to be_nil
          expect(body["updated_at"]).to be_nil
        end
      end
    end
  end
end
