class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can [:create, :read], List
      can [:update, :destroy, :assign_member, :unassign_member], List, owner_id: user.id 
      can [:create, :read], Card
      can [:update, :destroy], Card, { id: Card.joins(:list).where("lists.owner_id = ? or cards.owner_id = ?", user.id, user.id).pluck(:id) }
      can [:create, :read], Comment
      can [:update, :destroy], Comment do |comment|
        if comment.commentable.class == Card
          comment.user == user || comment.commentable.list.owner == user
        else
          comment.user == user || comment.commentable.commentable.list.owner == user
        end
      end
    else
      can :read, List, id: user.list_ids
      can [:create, :read], Card, { list_id: user.lists.pluck(:id) }
      can [:update, :destroy], Card, { owner_id: user.id }
      can [:update, :destroy], Comment, { user_id: user.id }
      can [:create, :read], Comment, commentable_type: 'Card', commentable_id: Card.where(list_id: user.lists.pluck(:id)).pluck(:id)
      can [:create, :read], Comment, commentable_type: 'Comment', commentable_id: Comment.where(commentable_type: 'Card', commentable_id: Card.where(list_id: user.lists.pluck(:id)).pluck(:id)).pluck(:id)
    end
  end
end
