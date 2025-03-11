require 'rails_helper'

RSpec.describe 'Info Token', type: :request do
  let(:user) { create(:user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  def authentication_headers_for(resource_owner, token=nil, token_type= :access_token)
    token = FactoryBot.create(:devise_api_token, resource_owner: resource_owner) if token.blank?
    token_value = token.send(token_type)

    { 'Authorization': "Bearer #{token_value}" }
  end

  context 'when the token is valid and on the header' do
    before do
      get "/users/tokens/info", headers: authentication_headers_for(user, devise_api_token), as: :json
    end

    it "return http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the authenticated resource owner" do
      expect(JSON.parse(response.body)["id"]).to eq(user.id)
      expect(JSON.parse(response.body)["email"]).to eq(user.email)
      expect(JSON.parse(response.body)["created_at"].to_date).to eq user.created_at.to_date
      expect(JSON.parse(response.body)["updated_at"].to_date).to eq user.updated_at.to_date
    end
  end

  context 'when the token is invalid and on the header' do
    let(:devise_api_token) { build(:devise_api_token, resource_owner: user) }

    before do
      get "/users/tokens/info", headers: authentication_headers_for(user, devise_api_token), as: :json
    end

    it 'returns http unauthorized' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns an error response' do
      expect(JSON.parse(response.body)["error"]).to eq 'invalid_token'
      expect(JSON.parse(response.body)["error_description"]).to eq(["Invalid token"])
    end

    it 'does not return the authenticated resource owner' do
      expect(JSON.parse(response.body)["id"]).to be_nil
      expect(JSON.parse(response.body)["email"]).to be_nil
      expect(JSON.parse(response.body)["created_at"]).to be_nil
      expect(JSON.parse(response.body)["updated_at"]).to be_nil
    end
  end
end
