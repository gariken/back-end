class OrdersCommands::Calculate
  def initialize(params, order_option_ids)
    @params = params
    @order_option_ids = order_option_ids
  end

  def execute
    distance = Mapbox.distance(@params[:lat_from], @params[:lon_from], @params[:lat_to], @params[:lon_to])
    if distance[:error].nil?
      distance = distance[:distance_in_km].round(1)
      tariffs = []
      order_option_prices = []

      if @order_option_ids
        @order_option_ids.each do |option_id|
          order_option_prices << OrderOption.find(option_id).price
        end
      end

      Tariff.all.order(position: 'asc').each_with_index do |tariff, i|

        if !("06:00"..."23:00").include?(Time.current.strftime("%H:%M"))
          price = tariff.night_price_per_kilometer
        else
          price = tariff.price_per_kilometer
        end

        calculated_amount = distance * price
        amount = calculated_amount < tariff.min_order_amount ? tariff.min_order_amount : calculated_amount
        order_option_prices.each do |option_price|
          amount += option_price
        end
        tariffs[i] = { id: tariff.id, name: tariff.name, amount: amount.round }
      end
      { distance: distance.round(1), tariffs: tariffs }
    else
      { errors: distance[:error] }
    end
  end
end
