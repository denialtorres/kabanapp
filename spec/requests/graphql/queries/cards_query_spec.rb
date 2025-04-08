require "rails_helper"

RSpec.describe "GraphQL, cards query", type: :request do
  let(:user) { create(:user) }
  let(:user_order) { create(:user) }

  let!(:board) { create(:board, user: user) }
  let(:devise_api_token) { create(:devise_api_token, resource_owner: user) }
  let(:devise_api_token_orders) { create(:devise_api_token, resource_owner: user_order) }

  let!(:cards) do
    create_list(:card, 15, column: board.columns.to_do)
  end

  let!(:filtered_card_by_name) { create(:card, column: board.columns.to_do, name: "wildcard") }
  let!(:filtered_card_by_description) { create(:card, column: board.columns.to_do, description: "wildcard") }
  let!(:done_card) { create(:card, column: board.columns.done, name: "this task is completed") }

  let!(:card_a) { create(:card, column: board.columns.to_do, deadline_at: 2.days.from_now, name: "Card A") }
  let!(:card_b) { create(:card, column: board.columns.in_progress, deadline_at: 1.day.from_now, name: "Card B") }
  let!(:card_c) { create(:card, column: board.columns.done, deadline_at: 3.days.from_now,  name: "Card C") }

  before do
    Card.all.each { |card| create(:user_card, user: user, card: card) }

    # for testing the ordering
    [ card_a, card_b, card_c ].each { |card| create(:user_card, user: user_order, card: card) }
  end

  it "retrieves all cards for the current user" do
    query = <<~GRAPHQL
      query {
        cards {
          nodes {
            name
            description
            status
          }
          pageInfo{
            endCursor
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors

    cards_data = response.parsed_body["data"]["cards"]

    expect(cards_data["nodes"]).to match_array(
      Card.first(10).map do |card|
        {
          "name" => card.name,
          "description" => card.description,
          "status" => card.status
        }
      end
    )

    expect(cards_data["pageInfo"]).to include("endCursor")
  end


  it "filters cards by query" do
    query = <<~GRAPHQL
      query {
        cards(query:"wild") {
          nodes {
            name
            description
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors

    cards_data = response.parsed_body["data"]["cards"]

    expect(cards_data["nodes"]).to match_array([
      { "name" => "wildcard", "description" => "Card description" },
      { "name" => "Card Name", "description" => "wildcard" }
    ])
  end

  it "filters cards by status" do
    query = <<~GRAPHQL
      query {
        cards(status: DONE) {
          nodes {
            name
            description
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors

    cards_data = response.parsed_body["data"]["cards"]
    expect(cards_data["nodes"]).to match_array([
      { "name" => "this task is completed", "description" => "Card description" },
      { "name" => "Card C", "description" => "Card description" }
    ])
    expect(cards_data["nodes"].size).to eq(2)
  end

  it "respects the max_page_size limit" do
    query = <<~GRAPHQL
      query {
        cards(first: 10) {
          nodes{
            name
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query },
                     headers: { Authorization: "Bearer #{devise_api_token.access_token}" }

    expect(response.parsed_body).not_to have_errors
    expect(response.parsed_body["data"]["cards"]["nodes"].size).to eq(10)
  end

  it "orders cards by status ascending" do
    query = <<~GRAPHQL
      query {
        cards(orderBy: STATUS_ASC) {
          nodes {
            name
            status
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }, headers: { Authorization: "Bearer #{devise_api_token_orders.access_token}" }

    expect(response.parsed_body).not_to have_errors

    statuses = response.parsed_body["data"]["cards"]["nodes"].map { |node| node["status"] }
    expect(statuses).to eq([ "to_do", "in_progress", "done" ])
  end

  it "orders cards by status descending" do
    query = <<~GRAPHQL
      query {
        cards(orderBy: STATUS_DESC) {
          nodes {
            name
            status
          }
        }
      }
    GRAPHQL

    post "/graphql", params: { query: query }, headers: { Authorization: "Bearer #{devise_api_token_orders.access_token}" }

    expect(response.parsed_body).not_to have_errors

    statuses = response.parsed_body["data"]["cards"]["nodes"].map { |node| node["status"] }

    expect(statuses).to eq([ "done", "in_progress", "to_do" ])
  end
end
