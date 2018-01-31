class Ability::DriverAbility
  include CanCan::Ability

  def initialize(driver)
    if driver.is_a?(Driver) &&  driver.status == 'active'
      can :update, Driver
      can :remove_image, Driver
      can :show, Driver
      can :initialization, Driver
      # can :authenticate_driver, Driver
      if driver.confirmed
        can :take, [Driver, Order]
        can :close, [Driver, Order]
        can :show, [Order, User]
        can :index, Order
        can :destroy, Order
        can :wait, Order
        can :start, Order
      end
    end
  end
end
