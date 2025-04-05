module Boards
  module Queries
    extend ActiveSupport::Concern

    included do
      field :boards, [ Types::BoardType ], null: false
    end

    def boards
      Board.all
    end
  end
end
