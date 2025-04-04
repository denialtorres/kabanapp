require 'rails_helper'

RSpec.describe FilterAndFindCards, type: :interactor do
  describe '#call' do
    let(:user) { create(:user) }
    let(:board) { create(:board) }
    let(:column_todo) { create(:column, board: board, position: 0) }
    let(:column_in_progress) { create(:column, board: board, position: 1) }
    let(:column_done) { create(:column, board: board, position: 2) }

    let!(:card1) { create(:card, name: "Fix bug #3427", description: "Fix login issue", column: column_todo) }
    let!(:card2) { create(:card, name: "Search 3427", description: "Add search bar", column: column_in_progress) }
    let!(:card3) { create(:card, name: "Something else", description: "Related to 3427", column: column_done) }

    let!(:card_other_user) { create(:card, name: "Not visible", description: "Not user’s card", column: column_todo) }

    subject(:context) do
      described_class.call(
        user: user,
        params: params
      )
    end

    before(:each) do
      # assign my cards
      create(:user_card, user: user, card: card1)
      create(:user_card, user: user, card: card2)
      create(:user_card, user: user, card: card3)
    end

    context 'when no query or status is provided' do
      let(:params) { {} }

      it 'returns all user cards' do
        expect(context).to be_success
        expect(context.cards).to match_array([ card1, card2, card3 ])
      end
    end

    context 'when query matches name or description' do
      let(:params) { { "query" => "3427" } }

      it 'returns matching cards' do
        expect(context).to be_success
        expect(context.cards).to match_array([ card1, card2, card3 ])
      end
    end

    context 'when query matches but status is provided and filters further' do
      let(:params) { { "query" => "3427", "status" => "to_do" } }

      it 'returns matching cards with column position 0' do
        expect(context).to be_success
        expect(context.cards).to contain_exactly(card1)
      end
    end

    context 'when status is in_progress only' do
      let(:params) { { "status" => "in_progress" } }

      it 'returns cards with column position 1' do
        expect(context).to be_success
        expect(context.cards).to contain_exactly(card2)
      end
    end

    context 'when status is invalid' do
      let(:params) { { "status" => "unknown" } }

      it 'returns all cards since status is ignored' do
        expect(context).to be_success
        expect(context.cards).to match_array([ card1, card2, card3 ])
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(user).to receive(:cards).and_raise(StandardError.new("Something went wrong"))
      end

      let(:params) { {} }

      it 'fails the context with an error message' do
        expect(context).to be_failure
        expect(context.message).to eq("Something went wrong")
        expect(context.error_code).to eq(:internal)
      end
    end
  end
end
