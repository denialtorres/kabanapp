class CardSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at,
             :updated_at, :position

  attribute :column do |card|
    card.column.name.parameterize.underscore
  rescue
    ""
  end
end
