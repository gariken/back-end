class Api::V1::UsersController < Api::V1::ApiController
  before_action :set_user, only: [:update, :show, :initialization, :remove_image, :close_debt]
  load_and_authorize_resource except: :accept_payment

  def initialization
    @user.coordinates = [params[:lat].to_f, params[:lon].to_f]
    if !@user.orders.blank?
      if last_payment = @user.orders.last.payment
        if last_payment.status == 'not_paid'
          debt = last_payment.amount
        else
          debt = nil
        end
      end
    else
      debt = nil
    end
    render json:
    {
      data:
          {
            tariffs: Tariff.where(status: 'active').order(position: 'asc'),
            user: @user,
            open_order: Order.where(driver_id: @user.id, status: 'opened').last,
            cards: @user.cards.as_json(except: [:token]),
            debt: debt
          }
    }
  end

  def show
    render json: { data: { open_order: @user.orders.where(status: 'opened').last, user: @user } }
  end

  def update
    if @user.update(user_params)
      render json: { data: { user: @user } }
    else
      render json: { data: { error: @user.errors } }, status: :unprocessable_entity
    end
  end

  def remove_image
    unless params[:photo].nil?
      @user.remove_photo!
      @user.save
    end
    render json: { data: { user: @user.as_json(except: [:payments_token]) } }
  end

  def bind_card
    render json: { data: CloudPayments::Client.bind_card(params[:name], request.remote_ip, params[:card_cryptogram_packet], params[:id]) }
  end

  def accept_payment
    params[:transaction_id] ||= params[:MD]
    params[:pa_res] ||= params[:PaRes]
    render json: { data: CloudPayments::Client.accept_payment(params[:transaction_id], params[:pa_res]) }
  end

  def cards
    render json: { data: { cards: current_user.cards.as_json(except: [:token]) } }
  end

  def remove_card
    card = Card.find_by(id: params[:card_id], user_id: current_user.id)
    if card
      card.delete
      render json: { data: { status: 'OK' } }
    else
      render json: { data: { error: 'Card not found for this user' } }, status: :unprocessable_entity
    end
  end

  def close_debt
    closing = UsersCommands::CloseDebt.new(current_user, params[:card_id]).execute
    if closing[:errors].nil?
      render json: { data: { status: 'OK' } }
    else
      render json: { data: { error: closing[:errors] } }, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.includes(:orders).find(params[:id])
    end

    def user_params
      the_params = params.permit(:name, :surname, :sex, :favorite_addresses, :photo, :email)
      the_params[:photo] = parse_image_data(params[:photo]) if params[:photo].class.to_s == "String"
      the_params
    end
end
