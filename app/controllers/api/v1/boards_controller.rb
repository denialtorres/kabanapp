module Api
  module V1
    class BoardsController < ApplicationController
      # skip rails auth tokens
      # fix for ActionController::InvalidAuthenticityToken (Can't verify CSRF token authenticity.):
      skip_before_action :verify_authenticity_token, railse: false
      before_action :authenticate_devise_api_token!
      before_action :set_current_user
      before_action :set_board, only: [:show, :update, :destroy]

      # GET /api/v1/boards
      def index
        boards = current_user.boards.all
        render json: BoardSerializer.new(boards).serializable_hash.to_json
      end

      # GET /api/v1/boards/:id
      def show
        render json: BoardSerializer.new(@board).serializable_hash.to_json
      end

      # POST /api/v1/boards
      def create
        board = current_user.boards.new(board_params)

        if board.save
          render json: BoardSerializer.new(board).serializable_hash.to_json, status: :created
        else
          render json: { error: board.errors.messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/boards/:id
      def update
        if @board.update(board_params)
          render json: BoardSerializer.new(@board).serializable_hash.to_json, status: :ok
        else
          render json:{ error: @board.errors.messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/boards/:id
      def destroy
        if @board.destroy
          head :no_content
        else
          render json:{ error: @board.errors.messages }, status: :unprocessable_entity
        end
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

      def board_params
        params.require(:board).permit(:name)
      end
    end
  end
end