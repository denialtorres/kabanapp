class PaginateCards
  include Interactor

  def call
    page_token = context.params[:page_token]
    cards = context.cards
    order_by = context.order_by

    page = if page_token.present?
             Rotulus::Page.new(cards, order: order_by, limit: 10).at(page_token)
           else
             Rotulus::Page.new(cards, order: order_by, limit: 10)
           end

    context.page = page
  end
end