class FilterAndFindCards
  include Interactor

  def call
    context.cards = user.cards.eager_load(:column).ransack(serach_params).result
  rescue StandardError => e
    context.fail!(message: e.message, error_code: :internal)
  end

  private

  delegate :user, :params, to: :context

  # ("columns"."position" = 2 AND (("cards"."name" ILIKE '%3427%') OR ("cards"."description" ILIKE '%3427%')))
  def serach_params
    {
      g: [
        {
          m: "or",
          name_cont_any: params[:query].presence,
          description_cont_any: params[:query].presence
        }
      ],
      column_position_eq: status_index[params["status"]].presence
    }.compact
  end


  def status_index
    {
      "to_do" => 0,
      "in_progress" => 1,
      "done" => 2
    }
  end
end
