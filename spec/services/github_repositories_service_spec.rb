require 'rails_helper'
require 'webmock/rspec'

RSpec.describe GithubRepositoriesService do
  let(:username) { 'denialtorres' }
  let(:service) { described_class.new(username) }

  describe '#fetch_repositories' do
    it 'returns a list of repositories', :vcr do
      repos = service.fetch_repositories
      expect(repos).to be_an(Array)
      expect(repos.first).to include('name', 'stargazers_count')
    end

    context 'when the request fails' do
      before do
        allow_any_instance_of(HTTParty::Response).to receive(:success?).and_return(false)
      end

      it 'returns an empty array when request fails', :vcr do
        expect(service.fetch_repositories).to eq([])
      end
    end
  end

  describe '#total_repositories' do
    it 'returns total number of repositories', :vcr do
      total = service.total_repositories
      expect(total).to be_a(Integer)
      expect(total).to be >= 0
    end

    it 'returns 0 when request fails', :vcr do
      allow_any_instance_of(HTTParty::Response).to receive(:success?).and_return(false)

      expect(service.total_repositories).to eq(0)
    end
  end

  describe '#fetch_repository_statistics_cache' do
    let(:mock_cache) do
      [
        { 'name' => 'dotfiles', 'stargazers_count' => 4, 'forks_count' => 0, 'watchers_count' => 4, 'open_issues_count' => 0 },
        { 'name' => 'ember-authentication', 'stargazers_count' => 1, 'forks_count' => 0, 'watchers_count' => 1, 'open_issues_count' => 9 }
      ]
    end

    it 'returns cached repository statistics' do
      allow(Rails.cache).to receive(:read).with("github_repos/#{username}").and_return(mock_cache)
      result = service.fetch_repository_statistics_cache

      expect(result[:total_repositories]).to eq(2)
      expect(result[:repositories].first[:name]).to eq('dotfiles')
    end

    it 'returns empty stats when cache is nil' do
      allow(Rails.cache).to receive(:read).with("github_repos/#{username}").and_return(nil)
      result = service.fetch_repository_statistics_cache

      expect(result).to eq({ total_repositories: 0, repositories: [] })
    end
  end

  describe '#fetch_all_repositories' do
    it 'fetches all repositories across multiple pages', :vcr do
      all_repos = service.fetch_all_repositories
      expect(all_repos).to be_an(Array)
      expect(all_repos.size).to be >= 0
    end
  end
end
