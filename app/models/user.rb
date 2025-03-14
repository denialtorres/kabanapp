class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :api

  has_many :boards, dependent: :destroy
  has_many :user_cards
  has_many :cards, through: :user_cards

  ROLES = %w[super_admin owner user].freeze

  validates :role, inclusion: { in: ROLES }
end
