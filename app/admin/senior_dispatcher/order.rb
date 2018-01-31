ActiveAdmin.register Order, namespace: :senior_dispatcher do
  actions :index, :show, :new, :create, :destroy

  includes :user, :driver, :tariff

  config.sort_order = 'removing_status_asc' && 'created_at_desc'

  payment_method_translation = {cash: 'наличные', cashless: 'безналичные'}
  config.current_filters = false
  preserve_default_filters!

  remove_filter :lat_from
  remove_filter :lat_to
  remove_filter :lon_from
  remove_filter :lon_to
  remove_filter :comment
  remove_filter :address_from
  remove_filter :address_to
  remove_filter :status
  remove_filter :updated_at
  remove_filter :amount
  remove_filter :distance
  remove_filter :waiting_minutes
  remove_filter :time_of_taking
  remove_filter :time_of_starting
  remove_filter :time_of_closing
  remove_filter :start_waiting_time
  remove_filter :intermediate_points
  remove_filter :options
  remove_filter :order_options
  remove_filter :payment

  filter :removing_status, as: :select, collection: Order.removing_statuses, label: "Статус удаления"
  filter :payment_method, as: :select, collection: Order.payment_methods.map { |p| [payment_method_translation[p[0].to_sym], p[1]]}, label: "Метод оплаты"

  permit_params :lat_from, :lon_from, :lat_to, :lon_to, :status, :address_from, :address_to, :payment_method,
                :comment, :tariff_id, :user_id, :amount

  index do
    column :status
    column :address_from
    column :address_to
    column :tariff_id do |order|
      tariff = order.tariff
      order.tariff_id.nil? ? '' : link_to("#{tariff.name}", "/admin/tariffs/#{tariff.id}")
    end
    column :user_id do |order|
      user = order.user
      order.user_id.nil? ? '' : link_to("#{user.name} #{user.surname}", "/admin/users/#{user.id}")
    end
    column :driver_id do |order|
      driver = order.driver
      order.driver_id.nil? ? '' : link_to("#{driver.name} #{driver.surname}", "/admin/drivers/#{driver.id}")
    end
    column :amount
    column :distance
    actions
  end

  show do
    attributes_table do
      row :id
      row :status
      row :removing_status
      row :payment_method do |order|
      if order.payment_method == "cash"
        "Наличные"
      elsif order.payment_method == "cashless"
        "Безналичные"
      end
    end
      row :comment
      row :rating
      row :review
      row :amount
      row :address_from
      row :address_to
      row :distance
      row :waiting_minutes
      row :time_of_taking
      row :start_waiting_time
      row :time_of_starting
      row :time_of_closing
      row :order_options do |order|
        opts = ""
        order.order_options.each do |opt|
          opts += "#{opt.description}, "
        end
        opts.chop.chop
      end
      row :user_id do |order|
        user = order.user
        order.user_id.nil? ? '' : link_to("#{user.name} #{user.surname}", "/admin/users/#{user.id}")
      end
      row :driver_id do |order|
        driver = order.driver
        order.driver_id.nil? ? '' : link_to("#{driver.name} #{driver.surname}", "/admin/drivers/#{driver.id}")
      end
      row :tariff_id do |order|
        tariff = order.tariff
        order.tariff_id.nil? ? '' : link_to("#{tariff.name}", "/admin/tariffs/#{tariff.id}")
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :address_from, input_html: { placeholder: "Москва, Пушкина, 1" }
      f.input :address_to, input_html: { placeholder: "Москва, Пушкина, 1" }
      f.input :lat_from
      f.input :lon_from
      f.input :lat_to
      f.input :lon_to
      f.input :amount, label: 'Наценка'
      f.input :comment
      f.input :order_options, as: :check_boxes, collection: OrderOption.all.map { |opt| ["#{opt.description}", opt.id] }
      # f.input :payment_method, as: :select, collection: Order.payment_methods.map { |p| [payment_method_translation[p[0].to_sym], p[0]]}
      f.input :tariff_id, input_html: { style: 'width:12%'}, as: :select, collection: Tariff.where(status: 'active').map { |t| ["#{t.name}", t.id] }
      inputs 'Пассажир' do
        f.input :user_name, label: 'Имя'
        f.input :user_surname, label: 'Фамилия'
        f.input :phone_number, label: 'Номер телефона (номер должен содержать 11 символов, если номер некорректен, пользователь не добавится)', input_html: { placeholder: "79123456789" }
      end
    end
    f.actions
  end

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank?
        extra_params = { "q": { "removing_status_eq": "0" } }
        params.merge! extra_params
      end
    end

    def create
      if ((!params[:order]['address_from'].blank? && !params[:order]['address_to'].blank?) || (!params[:order]['lat_from'].blank? && !params[:order]['lon_from'].blank? && !params[:order]['lat_to'].blank? && !params[:order]['lon_to'].blank?)) && !params[:order]['tariff_id'].blank?
        if !params[:order]['address_from'].blank? && !params[:order]['address_to'].blank?
          coordinates_from = Geocoder.coordinates(params[:order]['address_from'])
          params[:order][:lat_from] = coordinates_from[0]
          params[:order][:lon_from] = coordinates_from[1]

          coordinates_to = Geocoder.coordinates(params[:order]['address_to'])
          params[:order][:lat_to] = coordinates_to[0]
          params[:order][:lon_to] = coordinates_to[1]
        end
        if !params[:order]['phone_number'].blank? && params[:order]['phone_number'].length == 11
          user = User.find_by(phone_number: params[:order]['phone_number'])
          params[:order][:user_id] = user ? user.id : User.create!(
                                                        phone_number: Phony.normalize(params[:order]['phone_number'].gsub(/[^0-9]/, "").gsub(/^8/, "7")),
                                                        name: params[:order]['user_name'],
                                                        surname: params[:order]['user_surname'],
                                                        password: Random.new.rand(1111..9999)
                                                      ).id
        else
          params[:order][:user_id] = User.find_by(name: "Диспетчер").id
        end
        params[:order][:order_option_ids].delete("")
        order_option_ids = params[:order][:order_option_ids]
        order = OrdersCommands::Create.new(permitted_params[:order], params[:order][:tariff_id], order_option_ids, 0).execute
        if order[:errors].nil?
          redirect_to "/senior_dispatcher/orders/#{order['id']}"
        else
          @resource = Order.new(permitted_params[:order])
          render :new
        end
      else
        flash[:error] = "Проверьте, заполнили ли вы эти поля: Адрес начала, Адрес конца или Координаты, Тариф"
        @resource = Order.new(permitted_params[:order])
        render :new
      end
    end

    def destroy
      unless resource.status == 'closed'
        resource.cancel(User.find_by(name: "Диспетчер"))
      end
      redirect_to action: :index
    end
  end
end
