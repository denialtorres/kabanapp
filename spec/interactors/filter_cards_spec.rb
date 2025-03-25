require 'rails_helper'

RSpec.describe FilterCards, type: :interactor do
  describe '#call' do
    let(:user) { create(:user) }
    let!(:board) { create(:board) }
    let!(:cards) { create_list(:card, 15) }
    let!(:columns) { board.columns.pluck(:id) }

    before do
      cards.each do |card|
        card.update(column_id: columns.sample)
        create(:user_card, user: user, card: card)
      end
    end

    subject(:context) do
      described_class.call(
        user: user,
        params: params
      )
    end

    context 'when the cards are filtered by status to_do' do
      let(:params) { { "status" => "to_do" } }

      it 'returns only the to_do cards' do
        cards_in_todo = user.cards.joins(:column).where(columns: { position: 0 })
        expect(context).to be_success
        expect(context.filtered_cards.count).to eq(cards_in_todo.count)
      end
    end

    context 'when the cards are filtered by status in_progress' do
      let(:params) { { "status" => "in_progress" } }

      it 'returns only the in_progress cards' do
        cards_in_progress = user.cards.joins(:column).where(columns: { position: 1 })
        expect(context).to be_success
        expect(context.filtered_cards.count).to eq(cards_in_progress.count)
      end
    end

    context 'when the cards are filtered by status done' do
      let(:params) { { "status" => "done" } }

      it 'returns only the done cards' do
        cards_in_done = user.cards.joins(:column).where(columns: { position: 2 })
        expect(context).to be_success
        expect(context.filtered_cards.count).to eq(cards_in_done.count)
      end
    end

    context 'when no status filter is provided' do
      let(:params) { {} }

      it 'returns all user cards' do
        all_user_cards = user.cards.eager_load(:column)
        expect(context).to be_success
        expect(context.filtered_cards.count).to eq(all_user_cards.count)
      end
    end
  end
end
