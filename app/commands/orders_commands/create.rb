class OrdersCommands::Create
  def initialize(params, tariff_id, order_option_ids, card_id)
    @tariff_id = tariff_id
    @order = Order.new(params)
    @order_option_ids = order_option_ids
    @card_id = card_id ? card_id.to_i : nil
  end

  def execute
    user = User.find(@order.user_id)
    if !user.orders.pluck(:status).include? 'opened' or user.name == "Диспетчер"

      if !user.orders.blank?
        if user.orders.last.payment
          return { errors: "User has the debt #{user.orders.last.payment.amount}" } if user.orders.last.payment.status == 'not_paid'
        end
      end

      distance = Mapbox.distance(@order.lat_from, @order.lon_from, @order.lat_to, @order.lon_to)
      if distance[:error].nil?
        set_geo_params(distance)

        if tariff = Tariff.find_by(id: @tariff_id)
          set_amount(tariff)

          if @card_id == 0 || @card_id.nil?
            @order.payment_method = 'cash'
          else
            return { errors: 'Card not found' } unless card = Card.find_by(id: @card_id.to_i, user_id: @order.user_id)
            payment = CloudPayments::Client.check_card(@order.user_id, card.token)
            return { errors: { errors: 'Card error', message: payment[:message] } } if payment[:code] != 0
            @order.payment_method = 'cashless'
          end

          if @order.valid?
            @order.save
            set_options
            create_payment(@card_id)

            Driver.notify_about_order(@order, tariff)
            Driver.send_pushes_about_order(tariff)
            order_attr
          else
            { errors: @order.errors }
          end
        else
          { errors: 'Tariff not found' }
        end
      else
        { errors: distance[:error] }
      end
    else
      { errors: 'User has open orders' }
    end
  end

  private

    def set_geo_params(distance)
      @order.distance = distance[:distance_in_km].round(1)
      @order.address_from = Geocoder.search([@order.lat_from, @order.lon_from]).first.nil? ? 'Адрес не определен' : Geocoder.search([@order.lat_from, @order.lon_from]).first.address
      @order.address_to = Geocoder.search([@order.lat_to, @order.lon_to]).first.nil? ? 'Адрес не определен' : Geocoder.search([@order.lat_to, @order.lon_to]).first.address
    end

    def set_amount(tariff)
      @order.tariff = tariff
      if !("06:00"..."23:00").include?(Time.current.strftime("%H:%M"))
        price = tariff.night_price_per_kilometer
      else
        price = tariff.price_per_kilometer
      end

      amount = (@order.distance * price).round(0)

      if @order.amount.nil?
        @order.amount = amount < tariff.min_order_amount ? tariff.min_order_amount : amount
      else
        @order.amount += amount < tariff.min_order_amount ? tariff.min_order_amount : amount
      end
    end

    def set_options
      if @order_option_ids
        @order.order_option_ids = @order_option_ids
        amount_with_options = @order.amount
        @order.order_options.each do |option|
          amount_with_options += option.price
        end
        @order.update(amount: amount_with_options)
      end
    end

    def order_attr
      user = User.find(@order.user_id)
      @order.attributes.merge(
        user_phone: user.phone_number,
        user_name: user.name,
        order_options: @order.order_options
      )
    end

    def create_payment(card_id)
      payment = Payment.new(
        description: "Оплата заказа №#{@order.id}",
        amount: @order.amount,
        user_id: @order.user_id,
        order_id: @order.id
      )
      if @order.payment_method == 'cash'
        payment.payment_method = 'cash'
      elsif @order.payment_method == 'cashless'
        payment.payment_method = 'cash'
        payment.card_id = card_id
      end
      payment.save!
    end
end
