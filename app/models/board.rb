class Board < ApplicationRecord
  belongs_to :user
  has_many :columns, dependent: :destroy

  after_create :create_default_colums

  validates :name, presence: true

  private

  def create_default_colums
    columns.create(name: "To Do", position: 0)
    columns.create(name: "In Progress", position: 1)
    columns.create(name: "Done", position: 2)
  end
end
