module Api
  module V1
    class BoardsController < ApplicationController
      before_action :authenticate_devise_api_token!
      before_action :set_current_user
      before_action :set_board, only: [:show]

      # GET /api/v1/boards
      def index
        boards = current_user.boards.all
        render json: BoardSerializer.new(boards).serializable_hash.to_json
      end

      # GET /api/v1/boards/:id
      def show
        render json: BoardSerializer.new(@board).serializable_hash.to_json
      end

      private

      def set_current_user
        devise_api_token = current_devise_api_token
        @current_user = devise_api_token.resource_owner
      end

      def set_board
        @board = current_user.boards.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Board not found" }, status: :not_found
      end
    end
  end
end