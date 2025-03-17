class RepositoriesSerializer
  include JSONAPI::Serializer

  attributes :total_repositories

  set_id -> { nil }

  attribute :repositories do |object|
    object.repositories.map do |repo|
      RepositorySerializer.new(OpenStruct.new(repo)).serializable_hash[:data]
    end
  end
end