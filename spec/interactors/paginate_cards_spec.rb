require 'rails_helper'

RSpec.describe PaginateCards, type: :interactor do
  describe '#call' do
    let(:user) { create(:user) }
    let!(:board) { create(:board) }
    let!(:column) { board.columns.first }

    let!(:cards) do
      (1..25).map { |i| create(:card, column: column, created_at: i.hours.ago) }
    end

    let(:order_by) { { id: :asc } }

    subject(:context) do
      described_class.call(
        params: params,
        cards: Card.where(id: cards.map(&:id)),
        order_by: order_by
      )
    end

    context 'when no page_token is provided' do
      let(:params) { {} }

      it 'returns the first 10 cards and a valid next_page_token' do
        expect(context).to be_success
        expect(context.page.records.count).to eq(10)
        expect(context.page.records).to match_array(cards.first(10))
        expect(context.page.next_token).not_to be_nil
        expect(context.page.prev_token).to be_nil
      end
    end

    context 'when using next_page_token to fetch the second page' do
      let(:first_page_context) do
        described_class.call(
          params: {},
          cards: Card.where(id: cards.map(&:id)),
          order_by: order_by
        )
      end
      let(:params) { { "page_token" => first_page_context.page.next_token } }

      it 'returns the next 10 cards' do
        expect(first_page_context.page.next_token).not_to be_nil
        expect(first_page_context.page.prev_token).to be_nil

        expect(context).to be_success
        expect(context.page.records.count).to eq(10)

        expect(context.page.next_token).not_to be_nil
      end
    end
  end
end
