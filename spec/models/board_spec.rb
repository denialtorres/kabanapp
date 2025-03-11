require 'rails_helper'

RSpec.describe Board, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:columns).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end
end
