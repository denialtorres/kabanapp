require 'rails_helper'

RSpec.describe FindCards, type: :interactor do
  describe '#call' do
    let(:user) { create(:user) }
    let!(:board) { create(:board) }
    let!(:column) { board.columns.first }

    let!(:card1) { create(:card, name: "Fix bug #123", description: "Fix login issue", column: column) }
    let!(:card2) { create(:card, name: "Implement feature", description: "Add new search bar", column: column) }
    let!(:card3) { create(:card, name: "Refactor code", description: "Improve performance", column: column) }
    let!(:unrelated_card) { create(:card, name: "Unrelated task", description: "Something else", column: column) }

    let!(:filtered_cards) { Card.where(id: [ card1.id, card2.id, card3.id ]) }

    subject(:context) do
      described_class.call(
        params: params,
        filtered_cards: filtered_cards
      )
    end

    context 'when no query is provided' do
      let(:params) { {} }

      it 'returns all filtered cards' do
        expect(context).to be_success
        expect(context.cards).to match_array(filtered_cards)
      end
    end

    context 'when query matches a card name' do
      let(:params) { { "query" => "Fix bug" } }

      it 'returns only matching cards' do
        expect(context).to be_success
        expect(context.cards).to contain_exactly(card1)
      end
    end

    context 'when query matches a card description' do
      let(:params) { { "query" => "performance" } }

      it 'returns only matching cards' do
        expect(context).to be_success
        expect(context.cards).to contain_exactly(card3)
      end
    end

    context 'when query does not match any cards' do
      let(:params) { { "query" => "Non-existent task" } }

      it 'returns an empty result' do
        expect(context).to be_success
        expect(context.cards).to be_empty
      end
    end
  end
end
