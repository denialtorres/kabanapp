module Types
  class CardStatusType < Types::BaseEnum
    description "Possible statuses for a card"

    value "TO_DO", "To do", value: "to_do"
    value "IN_PROGRESS", "In progress", value: "in_progress"
    value "DONE", "Done", value: "done"
  end
end
