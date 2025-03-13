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

      expect(board.columns.pluck(:position)).to eq(["to_do", "in_progress", "done"])
    end
  end
end
