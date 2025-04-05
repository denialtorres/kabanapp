module Mutations
  module Boards
    class Add < BaseMutation
      type Types::BoardType, null: false

      argument :name, String, required: true

      def resolve(name:)
        context[:current_user].boards.create!(name: name)
      end
    end
  end
end
