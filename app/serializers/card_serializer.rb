class CardSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :description, :created_at,
             :updated_at, :deadline_at

  attribute :column do |card|
    card.column.name.parameterize.underscore
  rescue
    ""
  end

  attribute :assigned_users do |card|
    card.user_cards.map do |user_card|
      {
        email: user_card.user.email,
        role:  user_card.user.role
      }
    end
  end
end
