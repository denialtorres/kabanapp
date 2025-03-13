class Card < ApplicationRecord
  belongs_to :column
  has_many :user_cards
  has_many :users, through: :user_cards

  validates :name, presence: true
  validates :description, presence: true

  default_scope { order(:position) }

  def status
    column.position
  end
end
