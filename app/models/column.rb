class Column < ApplicationRecord
  belongs_to :board
  has_many :cards, dependent: :destroy

  enum :position, [ :to_do, :in_progress, :done ]

  validates :name, presence: true
  validates :position, presence: true

  default_scope { order(:position) }

  scope :to_do, -> { where(position: :to_do).first }
  scope :in_progress, -> { where(position: :in_progress).first }
  scope :done, -> { where(position: :done).first }

  def self.ransackable_attributes(auth_object = nil)
    [ "position" ]
  end
end
