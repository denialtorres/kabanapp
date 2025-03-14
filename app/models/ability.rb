class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    case user.role
    when 'super_admin'
      super_admin_abilities
    when 'owner'
      owner_abilities(user)
    when 'user'
      user_abilities(user)
    end

    public_abilities
  end

  private

  def super_admin_abilities
    can :manage, :all
  end

  def owner_abilities(user)
    # owners can manage cards as long as they are the creators of the board
    can [:create, :update, :assign, :move, :unassign], Card, column: { board: { user_id: user.id } }

    can [:create, :update], Board
    # board authors and super admins can delete boards
    can :destroy, Board, user_id: user.id
  end

  def user_abilities(user)
    # regular users can only move cards they are assigned to
    can :move, Card, user_cards: { user_id: user.id }
  end

  def public_abilities
    # anyone can see the boards and the cards
    can :read, Board
    can :read, Card
  end
end
