require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'Devise modules' do
    let(:user) { create(:user, password: 'password123') }

    it 'authenticates with a valid password' do
      expect(user.valid_password?('password123')).to be_truthy
    end

    it 'fails authentication with an invalid password' do
      expect(user.valid_password?('wrongpassword')).to be_falsey
    end
  end
end