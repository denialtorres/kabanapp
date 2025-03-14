class Card < ApplicationRecord
  belongs_to :column
  has_many :user_cards
  has_many :users, through: :user_cards

  validates :name, presence: true
  validates :description, presence: true
  # pending fix test
  # validates :deadline_at, presence: true

  def status
    column.position
  end
end
