require 'rails_helper'

RSpec.describe Card, type: :model do
  describe "associations" do
    it { should belong_to(:column) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end
end
