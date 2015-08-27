class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin?
        can :access, :rails_admin
        can :dashboard
        can :manage, :all
      else
        can [:index, :show, :add_to_cart, :add_to_wishlist, :wishlist,:delete_from_wishlist], Book
        can [:new, :create], Rating,     user: user
        can :read,   [Category, User]
        can :manage, Order,     user: user
      end
    else
      can :read, [Book, Category,Rating]
    end
  end

end
