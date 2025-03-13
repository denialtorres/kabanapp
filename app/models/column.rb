class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, dependent: :destroy

  enum :position, [ :to_do, :in_progress, :done ]

  validates :name, presence: true
  validates :position, presence: true

  default_scope { order(:position) }
end
