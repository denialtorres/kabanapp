class SyncRepos < ApplicationJob
  queue_as :critical

  def perform
    User::GITHUB_USERS.each do |username|
      client = GithubRepositoriesService.new(username)

      # fetch all repositories across all pages
      repos = client.fetch_all_repositories

      # put the full list in Redis cache
      Rails.cache.write("github_repos/#{username}", repos, expires_in: 24.hours)
    end
  end
end
