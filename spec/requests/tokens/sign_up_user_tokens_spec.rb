require 'rails_helper'

RSpec.describe 'User Token Sign Up', type: :request do
  let(:valid_params) do
    {
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123'
    }
  end

  let(:invalid_params) do
    {
      email: 'invalid-email',
      password: 'short',
      password_confirmation: 'mismatch'
    }
  end

  describe 'POST /users/tokens/sign_up' do
    context 'with valid parameters' do
      it 'creates a new user and returns a token' do
        post '/users/tokens/sign_up', params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
        expect(JSON.parse(response.body)).to have_key('refresh_token')
        expect(JSON.parse(response.body)).to have_key('expires_in')
        expect(JSON.parse(response.body)).to have_key('token_type')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post '/users/tokens/sign_up', params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq(
          {
            'error' => 'resource_owner_create_error',
            'error_description' => [
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
