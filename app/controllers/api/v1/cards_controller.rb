module Api
  module V1
    class CardsController < BaseController
      before_action :set_board, only: [ :create, :update, :assign, :unassign ]
      before_action :set_card, only: [ :update, :assign, :unassign ]

      # POST /api/v1/boards/:board_id/cards
      def create
        @card = column.cards.new(card_params.except(:status))

        authorize! :create, @card

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

      # POST /api/v1/boards/:board_id/cards/:id/assign
      def assign
        authorize! :assign, @card

        assined_user = User.find(card_params[:user_id])

        if @card.user_cards.create(user: assined_user)
          render json: CardSerializer.new(@card).serializable_hash.to_json, status: :ok
        else
          render json: @card.errors, status: :unprocessable_entity
        end
      end

      # POST /api/v1/boards/:board_id/cards/:id/unassign
      def unassign
        authorize! :unassign, @card

        assigned_card = @card.user_cards.where(user_id: card_params[:user_id])

        if assigned_card.destroy_all
          render json: CardSerializer.new(@card).serializable_hash.to_json, status: :ok
        else
          render json: @card.errors, status: :unprocessable_entity
        end
      end

      # GET /api/v1/cards/my_cards
      def my_cards
        payload = MyCardsOrganizer.call(user: current_user, params: params)

        if payload.success?
          render json: PaginatedCardsSerializer.new(payload.page).serializable_hash
        else
          render json: { error: result.error }, status: :unprocessable_entity
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
        params.require(:card).permit(:name, :description, :status, :user_id)
      end

      def sort_index
        {
          "status_desc" => {
            "columns.position" => {
              direction: :desc,
              model: Column
            }
          },
          "status_asc" => {
            "columns.position" => {
              direction: :asc,
              model: Column
            }
          },
          "deadline_asc" => {
            deadline_at: :asc
          },
          "deadline_desc" => {
            deadline_at: :desc
          }
        }
      end
    end
  end
end
