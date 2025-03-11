class Card < ApplicationRecord
  belongs_to :column

  validates :name, presence: true
  validates :position, presence: true

  default_scope { order(:position) }
end
