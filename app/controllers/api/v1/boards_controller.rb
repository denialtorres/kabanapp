module Api
  module V1
    class BoardsController < BaseController
      before_action :set_board, only: [ :show, :update, :destroy ]

      # GET /api/v1/boards
      def index
        boards = Board.accessible_by(current_ability)

        render json: BoardSerializer.new(boards).serializable_hash.to_json
      end

      # GET /api/v1/boards/:id
      def show
        authorize! :read, @board

        render json: BoardSerializer.new(@board).serializable_hash.to_json
      end

      # POST /api/v1/boards
      def create
        @board = current_user.boards.new(board_params)

        authorize! :create, @board

        if @board.save
          render json: BoardSerializer.new(@board).serializable_hash.to_json, status: :created
        else
          render json: { error: @board.errors.messages }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/boards/:id
      def update
        authorize! :update, @board

        if @board.update(board_params)
          render json: BoardSerializer.new(@board).serializable_hash.to_json, status: :ok
        else
          render json: { error: @board.errors.messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/boards/:id
      def destroy
        authorize! :destroy, @board

        if @board.destroy
          head :no_content
        else
          render json: { error: @board.errors.messages }, status: :unprocessable_entity
        end
      end

      private

      def set_board
        @board = Board.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Board not found" }, status: :not_found
      end

      def board_params
        params.require(:board).permit(:name)
      end
    end
  end
end
