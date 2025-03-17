require 'httparty'
# username = "denialtorres"
# c = GithubRepositoriesService.new(username)
class GithubRepositoriesService
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize(username)
    @username = username
    @options = {
      query: {
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      },
      headers: {
        "User-Agent" => "custom-app"
      }
    }
  end

  def fetch_repositories
    response = self.class.get("/users/#{@username}/repos", @options)
    return [] unless response.success?
    response.parsed_response
  end

  def total_repositories
    response = self.class.get("/users/#{@username}", @options)
    return 0 unless response.success?
    response.parsed_response["public_repos"].to_i
  end
end