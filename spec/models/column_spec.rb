require 'rails_helper'

RSpec.describe Column, type: :model do
  describe "associations" do
    it { should belong_to(:board) }
    it { should have_many(:cards).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:position) }
  end

  describe "default scope" do
    it "orders columns by position" do
      board = create(:board)
      column1 = create(:column, board: board, position: 2)
      column2 = create(:column, board: board, position: 1)

      expect(board.columns.pluck(:id)).to eq([column2.id, column1.id])
    end
  end
end