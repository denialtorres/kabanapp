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
    # Owners can manage cards they own
    can [ :create, :update, :assign, :move ], Card, user_cards: { user_id: user.id, role: "owner" }

    # Regular users can only move cards they are assigned to
    can :move, Card, user_cards: { user_id: user.id, role: "user" }
  end
end
