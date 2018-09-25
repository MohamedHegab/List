class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can [:create, :read], List
      can [:update, :destroy, :assign_member, :unassign_member], List, owner_id: user.id 
    else
      can :read, :all
    end
  end
end
