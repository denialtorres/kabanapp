module Types
  class CardOrderType < Types::BaseEnum
    description "Possible orders for a card list"

    value "STATUS_ASC", value: "status_asc"
    value "STATUS_DESC", value: "status_desc"
    value "DEADLINE_ASC", value: "deadline_asc"
    value "DEADLINE_DESC", value: "deadline_desc"
  end
end
