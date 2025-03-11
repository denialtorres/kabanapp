require 'rails_helper'

RSpec.describe 'User Token Sign In', type: :request do
  let!(:user) { create(:user) }
  let(:good_password) { "password123" }
  let(:url) { '/users/tokens/sign_in' }

  let(:valid_params) do
    {
      email: user.email,
      password: good_password
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: user.email,
        password: 'wrong_password'
      }
    }
  end

  describe 'POST /users/tokens/sign_in' do
    context 'with valid credentials' do
      before { post url, params: valid_params }

      it 'returns http ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the user email' do
        expect(JSON.parse(response.body)["resource_owner"]["email"]).to eq(user.email)
      end

      it 'returns an access-token' do
        expect(JSON.parse(response.body)["token"]).to be_present
      end

      it 'returns a token-type' do
        expect(JSON.parse(response.body)['token_type']).to be_present
        expect(JSON.parse(response.body)['token_type']).to eq('Bearer')
      end
    end

    context 'when invalid params are sent' do
      before { post url, params: invalid_params }

      it 'returns http bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error messages' do
        expect(JSON.parse(response.body)['error']).to be_present
      end
    end
  end
end
