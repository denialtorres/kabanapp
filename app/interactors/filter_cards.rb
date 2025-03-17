class FilterCards
  include Interactor

  def call
    user = context.user
    context.status = context.params["status"]

    context.filtered_cards = if context.status.blank?
                              user.cards.eager_load(:column)
    else
                              user.cards.eager_load(:column).ransack(status_filter).result
    end
  end

  private

  def status_filter
    { column_position_eq: status_index[context.status] }
  end

  def status_index
    {
      "to_do" => 0,
      "in_progress" => 1,
      "done" => 2
    }
  end
end
