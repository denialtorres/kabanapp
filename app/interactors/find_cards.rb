class FindCards
  include Interactor

  def call
    context.query = context.params["query"]

    context.cards = if context.query.blank?
                      context.filtered_cards
                    else
                      context.filtered_cards.ransack(search_params).result
                    end
  end

  private

  def search_params
    { name_cont_any: context.query, description_cont_any: context.query, m: "or" }
  end
end
