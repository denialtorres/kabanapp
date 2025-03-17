class MyCardsOrganizer
  include Interactor::Organizer

  organize FilterCards,
           FindCards,
           SortCards,
           PaginateCards
end