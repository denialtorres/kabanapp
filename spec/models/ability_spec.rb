require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  let(:super_admin) { create(:user, role: "super_admin") }
  let(:owner) { create(:user, role: "owner") }
  let(:regular_user) { create(:user, role: "user") }
  let(:board) { create(:board, user: owner) }
  let(:another_board) { create(:board) }
  let(:column) { create(:column, board: board) }
  let(:card) { create(:card, column: column) }
  let(:another_card) { create(:card) }
  let(:user_card) { create(:user_card, user: regular_user, card: card) }

  context "Super Admin" do
    subject(:ability) { Ability.new(super_admin) }

    it "can manage all resources" do
      expect(ability).to be_able_to(:manage, :all)
    end
  end

  context "Owner" do
    subject(:ability) { Ability.new(owner) }

    it "can create and update boards" do
      expect(ability).to be_able_to(:create, Board)
      expect(ability).to be_able_to(:update, board)
    end

    it "can delete their own boards" do
      expect(ability).to be_able_to(:destroy, board)
    end

    it "cannot delete boards they do not own" do
      expect(ability).not_to be_able_to(:destroy, another_board)
    end

    it "can manage cards in their boards" do
      expect(ability).to be_able_to(:create, card)
      expect(ability).to be_able_to(:update, card)
      expect(ability).to be_able_to(:assign, card)
      expect(ability).to be_able_to(:move, card)
      expect(ability).to be_able_to(:unassign, card)
    end

    it "cannot manage cards in other owners' boards" do
      expect(ability).not_to be_able_to(:update, another_card)
    end
  end

  context "Regular User" do
    subject(:ability) { Ability.new(regular_user) }

    it "can move only assigned cards" do
      user_card
      expect(ability).to be_able_to(:move, card)
      expect(ability).not_to be_able_to(:move, another_card)
    end

    it "cannot create, update, or delete boards" do
      expect(ability).not_to be_able_to(:create, Board)
      expect(ability).not_to be_able_to(:update, board)
      expect(ability).not_to be_able_to(:destroy, board)
    end
  end

  context "Public Abilities" do
    it "allows anyone to read boards and cards" do
      expect(Ability.new(super_admin)).to be_able_to(:read, Board)
      expect(Ability.new(owner)).to be_able_to(:read, Board)
      expect(Ability.new(regular_user)).to be_able_to(:read, Card)
    end
  end
end
