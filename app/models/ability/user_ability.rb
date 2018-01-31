class Ability::UserAbility
  include CanCan::Ability

  def initialize(user)
    if user.is_a?(User) && user.status == 'active'
      # can :authenticate_user, User
      can :index, Order
      can :create, Order
      can :show, [Order, Driver, User]
      can :update, User
      can :near_drivers, User
      can :initialization, User
      can :destroy, Order
      can :estimate, Order
      can :preliminary, Order
      can :remove_image, User
      can :bind_card, User
      can :accept_payment, User
      can :remove_card, User
      can :cards, User
      can :close_debt, User
    end
  end
end
