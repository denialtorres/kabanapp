module Api
  module V1
    class CardsController < BaseController
      before_action :set_board, only: [ :create, :update ]
      before_action :set_card, only: [ :update ]

      # POST /api/v1/boards/:board_id/cards
      def create
        @card = column.cards.new(card_params.except(:status))

        if @card.save
          @card.update(column: column) if card_params[:status].present?
          render json: CardSerializer.new(@card).serializable_hash.to_json, status: :created
        else
          render json: @card.errors, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/boards/:board_id/cards/:id
      def update
        authorize! dynamic_action, @card

        if @card.update(card_params.except(:status))
          @card.update(column: column) if card_params[:status].present?

          render json: CardSerializer.new(@card).serializable_hash.to_json, status: :ok
        else
          render json: @card.errors, status: :unprocessable_entity
        end
      end

      private

      def column
        @board.columns.find_by(position: card_params[:status]) ||
        @board.columns.find_by(position: "to_do")
      end

      def set_board
        @board = Board.find(params[:board_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Board not found" }, status: :not_found
      end

      def set_card
        @card = @board.cards.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Card not found" }, status: :not_found
      end

      def card_params
        params.require(:card).permit(:name, :description, :status)
      end
    end
  end
end
