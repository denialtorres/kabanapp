module Api
  module V1
    class CardsController < ApplicationController
      # skip rails auth tokens
      # fix for ActionController::InvalidAuthenticityToken (Can't verify CSRF token authenticity.):
      skip_before_action :verify_authenticity_token, railse: false
      before_action :authenticate_devise_api_token!
      before_action :set_current_user
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

      def set_current_user
        devise_api_token = current_devise_api_token
        @current_user = devise_api_token.resource_owner
      end

      def set_board
        @board = current_user.boards.find(params[:board_id])
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
