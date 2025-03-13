class Card < ApplicationRecord
  belongs_to :column

  validates :name, presence: true
  validates :description, presence: true

  default_scope { order(:position) }

  def status
    column.position
  end
end
