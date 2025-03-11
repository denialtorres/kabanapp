require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "associations" do
    it { should belong_to(:column) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:position) }
  end

  describe "default scope" do
    it "orders cards by position" do
      column = create(:column)
      card1 = create(:card, column: column, position: 2)
      card2 = create(:card, column: column, position: 1)

      expect(column.cards.pluck(:id)).to eq([ card2.id, card1.id ])
    end
  end
end
