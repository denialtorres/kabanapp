class BoardSerializer
  include JSONAPI::Serializer

  attributes :id, :user_id, :name, :created_at, :updated_at
end
