class RepositorySerializer
  include JSONAPI::Serializer

  set_id -> { nil }

  attributes :name, :stars, :forks, :watchers, :open_issues
end
