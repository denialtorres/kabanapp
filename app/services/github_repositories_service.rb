require 'httparty'

class GithubRepositoriesService
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize(username)
    @username = username
    @options = {
      query: {
        client_id: ENV['GITHUB_CLIENT_ID'],
        client_secret: ENV['GITHUB_SECRET_ID'],
        per_page: 30
      },
      headers: {
        'Accept' => 'application/vnd.github.v3+json',
        "User-Agent" => "custom-app"
      }
    }
  end

  def fetch_repositories(page: 1)
    response = self.class.get("/users/#{@username}/repos", query: @options[:query].merge(page: page))
    return [] unless response.success?

    response.parsed_response
  end

  def total_repositories
    response = self.class.get("/users/#{@username}", @options)
    return 0 unless response.success?

    response.parsed_response["public_repos"].to_i
  end

  def fetch_repository_statistics_cache
    cached_data = Rails.cache.read("github_repos/#{@username}")
    return { total_repositories: 0, repositories: [] } unless cached_data

    stats = cached_data.map do |repo|
      {
        name: repo["name"],
        stars: repo["stargazers_count"],
        forks: repo["forks_count"],
        watchers: repo["watchers_count"],
        open_issues: repo["open_issues_count"]
      }
    end

    return { total_repositories: cached_data.size, repositories: stats }
  end

  def fetch_all_repositories
    total_repos = total_repositories
    total_pages = (total_repos.to_f / 30).ceil
    all_repos = []

    (1..total_pages).each do |page|
      all_repos.concat(fetch_repositories(page: page))
    end

    all_repos
  end
end
