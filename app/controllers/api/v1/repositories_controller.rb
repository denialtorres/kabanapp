module Api
  module V1
    class RepositoriesController < BaseController
      def summary
        username = params[:username]
        service = GithubRepositoriesService.new(username)
        summary_data = OpenStruct.new(service.fetch_repository_statistics_cache)  # Convert Hash to Object

        render json: RepositoriesSerializer.new(summary_data).serializable_hash
      end
    end
  end
end
