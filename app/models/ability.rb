class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can [:create, :read], List
      can [:update, :destroy, :assign_member, :unassign_member], List, owner_id: user.id 
      can [:create, :read], Card
      can [:update, :destroy], Card, { id: Card.joins(:list).where("lists.owner_id = ? or cards.owner_id = ?", user.id, user.id).pluck(:id) }
    else
      can :read, List, id: user.list_ids
      can [:create, :read], Card, { list_id: user.lists.pluck(:id) }
      can [:update, :destroy], Card, { owner_id: user.id }
    end
  end
end
