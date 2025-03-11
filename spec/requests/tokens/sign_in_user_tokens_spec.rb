require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'User Token Sign In', type: :request do
  path "/users/tokens/sign_in" do
    post "Authenticates an existing user and returns tokens" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: "test@example.com" },
          password: { type: :string, format: :password, example: "password123" }
        },
        required: ["email", "password"]
      }

      response "200", "User authenticated successfully" do
        let!(:user) { create(:user, password: "password123") }
        let(:user_params) { { email: user.email, password: "password123" } }

        run_test! do
          expect(response).to have_http_status(:ok)
          body = JSON.parse(response.body)
          expect(body["resource_owner"]["email"]).to eq(user.email)
          expect(body["token"]).to be_present
          expect(body["token_type"]).to eq("Bearer")
        end
      end

      response "401", "Invalid credentials" do
        let!(:user) { create(:user, password: "password123") }
        let(:user_params) { { email: user.email, password: "wrong_password" } }

        run_test! do
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)["error"]).to be_present
        end
      end
    end
  end
end
