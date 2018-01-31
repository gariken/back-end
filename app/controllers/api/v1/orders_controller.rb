class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_order, only: [:take, :close, :show, :destroy, :estimate, :start, :wait]
  load_and_authorize_resource

  def index
    if params[:driver_id].nil? && params[:user_id].nil?
      @orders = Order.includes(:order_options).where("status = ? AND tariff_id IN (?) AND removing_status = ? AND driver_id IS ?", 0, Tariff.where("priority <= ?", current_driver.tariff.priority).pluck(:id), 0, nil)
    elsif !params[:user_id].nil?
      @orders = Order.includes(:order_options).where(user_id: params[:user_id], removing_status: 'active')
    else
      @orders = Order.includes(:order_options).where(driver_id: params[:driver_id], removing_status: 'active')
    end
    render json: { data: { orders: @orders.map { |o| o.attributes.merge({ order_options: o.order_options }) } } }
  end

  def show
    render json: { data: { order: @order.attributes.merge({ order_options: @order.order_options }) } }
  end

  def preliminary
    @preliminary_order = OrdersCommands::Calculate.new(order_params, params[:order_option_ids]).execute
    if @preliminary_order[:errors].nil?
      render json: { data: { preliminary_order: @preliminary_order } }
    else
      render json: { data: { error: @preliminary_order[:errors] } }, status: :unprocessable_entity
    end
  end

  def create
    @order = OrdersCommands::Create.new(order_params, params[:tariff_id], params[:order_option_ids], params[:card_id]).execute
    if @order[:errors].nil?
      render json: { data: { order: @order } }
    else
      render json: { data: { error: @order[:errors] } }, status: :unprocessable_entity
    end
  end

  def destroy
    if @order.status == 'opened'
      @order.cancel(current_user || current_driver)
      render json: { data: { status: "OK" } }
    else
      render json: { data: { error: "Order is closed" } }, status: :unprocessable_entity
    end
  end

  def start
    @order.start_driving
    render json: { data: { status: 'OK', order: @order.attributes.merge({ order_options: @order.order_options }) } }
  end

  def wait
    @order.start_waiting
    render json: { data: { status: 'OK', order: @order.attributes.merge({ order_options: @order.order_options }) } }
  end

  def take
    unless @order.driver_id
      unless params[:driver_id].nil?
        driver = Driver.find(params[:driver_id])
        if @order.payment_method == 'cash' && driver.balance > 0
          @order = @order.take(params[:driver_id])
          if @order[:errors].nil?
            render json: { data: { status: 'OK', order: @order.attributes.merge({ order_options: @order.order_options }) } }
          else
            render json: { data: { error: @order[:errors] } }, status: :unprocessable_entity
          end
        else
          render json: { data: { error: "Driver balance must be greater than 0"} }, status: :unprocessable_entity
        end
      else
        render json: { data: { error: 'Invalid driver id', order: @order } }, status: :unprocessable_entity
      end
    else
      render json: { data: { error: 'Order has driver', order: @order } }, status: :unprocessable_entity
    end
  end

  def close
    if @order.status == 'opened'
      params[:payed] = true if params[:payed].nil? # crutch for old versions :(
      params[:payed] = str_to_bool(params[:payed])

      if !!params[:payed] == params[:payed]
        @order = @order.close(params[:payed])
        if @order[:errors].nil?
          render json: { data: { status: 'OK', order: @order.attributes.merge({ order_options: @order.order_options }) } }
        else
          render json: { data: { status: 'OK', error: 'Payment error', message: @order[:errors] } }
        end
      else
        render json: { data: { error: 'Payed is invalid' } }, status: :unprocessable_entity
      end
    else
      render json: { data: { error: 'Order is closed' } }, status: :unprocessable_entity
    end
  end

  def estimate
    unless params[:rating].nil? || params[:rating].to_i > 5 || params[:rating].to_i < 1
      @order.estimate(params[:rating], params[:review])
      render json: { data: { status: 'OK', order: @order.attributes.merge({ order_options: @order.order_options }) } }
    else
      render json: { data: { error: 'Invalid rating value', order: @order.attributes.merge({ order_options: @order.order_options }) } }, status: :unprocessable_entity
    end
  end

  private
    def set_order
      @order = Order.includes(:order_options).find(params[:id])
    end

    def order_params
      params.permit(:lat_from, :lat_to, :lon_from, :lon_to, :user_id, :comment)
    end

    def str_to_bool(obj)
      if obj == "false"
        obj = false
      elsif obj == "true"
        obj = true
      end
      obj
    end
end
