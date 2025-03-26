require 'rails_helper'

describe Api::V1::BoardsController, type: :controller do
  let(:user) { create(:user, role: "owner") }
  let!(:boards) { create_list(:board, 5, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }

  before(:each) do
    request.headers["Authorization"] = "Bearer #{devise_api_token.access_token}"
    Rails.cache.clear
  end

  it "GET index" do
    get :index

    expect(response).to have_http_status(:success)
  end

  context "when rate limiting is triggered" do
    it "triggers the rate limiter" do
      5.times do
        RequestHelpers.execute("GET", Api::V1::BoardsController, "index", {}, devise_api_token.access_token)
      end

      final_response = RequestHelpers.execute("GET", Api::V1::BoardsController, "index", {}, devise_api_token.access_token)

      expect(final_response[:request].status).to be(429)
    end
  end
end
