class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    # if user.super_admin?
    #   can :manage, :all
    # else
    #   can :read, Board
    #   can :read, Card
    # end

    can :read, Board
    can :read, Card

    # Owners can manage cards aslong they are the creators of the board
    if user.role == "owner"
      can [:create, :update, :assign, :move], Card, column: { board: { user_id: user.id } }
    end

    if user.role == "user"
      # Regular users can only move cards they are assigned to
      can :move, Card, user_cards: { user_id: user.id }
    end
  end
end
