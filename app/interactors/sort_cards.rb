class SortCards
  include Interactor

  def call
    order_by = sort_index[context.params[:order_by]]
    context.order_by = order_by
  end

  private

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
