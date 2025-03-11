require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'User Token Sign Up', type: :request do
  path "/users/tokens/sign_up" do
    post "Registers a new user and returns authentication tokens" do
      tags "Authentication"
      consumes "application/json"
      produces "application/json"

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, format: :email, example: "test@example.com" },
          password: { type: :string, format: :password, example: "password123" },
          password_confirmation: { type: :string, format: :password, example: "password123" }
        },
        required: [ "email", "password", "password_confirmation" ]
      }

      response "201", "User created successfully" do
        let(:user) do
          {
            email: "test@example.com",
            password: "password123",
            password_confirmation: "password123"
          }
        end

        run_test! do
          expect(response).to have_http_status(:created)
          expect(JSON.parse(response.body)).to have_key("token")
          expect(JSON.parse(response.body)).to have_key("refresh_token")
          expect(JSON.parse(response.body)).to have_key("expires_in")
          expect(JSON.parse(response.body)).to have_key("token_type")
        end
      end

      response "422", "Validation errors" do
        let(:user) do
          {
            email: "invalid-email",
            password: "short",
            password_confirmation: "mismatch"
          }
        end

        run_test! do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)).to eq(
            {
              "error" => "resource_owner_create_error",
              "error_description" => [
                "Email is invalid",
                "Password confirmation doesn't match Password",
                "Password is too short (minimum is 6 characters)"
              ]
            }
          )
        end
      end
    end
  end
end
