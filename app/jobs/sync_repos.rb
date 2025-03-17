class SyncRepos < ApplicationJob
  queue_as :critical

  def perform
    User::GITHUB_USERS.each do |username|
      client = GithubRepositoriesService.new(username)
    # here we made the external call and cache the response
      Rails.cache.fetch("github_repos/#{username}", expires_in: 24.hours) do
        client.fetch_repositories
      rescue StandardError
        true
      end
    end
  end
end


