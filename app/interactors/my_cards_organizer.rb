class MyCardsOrganizer
  include Interactor::Organizer

  organize FilterAndFindCards,
           SortCards,
           PaginateCards
end
