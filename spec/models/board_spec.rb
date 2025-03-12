require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:board) { create(:board) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:columns).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "callbacks" do
    context "when the board is created" do
      it "generates his default columns" do
        board
        expect(board.columns.size).to eq(3)
      end
    end
  end
end
