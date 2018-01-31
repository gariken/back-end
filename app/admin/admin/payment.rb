ActiveAdmin.register Payment do
  actions :index, :show, :edit, :update

  config.current_filters = false
  preserve_default_filters!
  remove_filter :description
  remove_filter :amount
  remove_filter :data
  remove_filter :card_id
  remove_filter :order

  payment_method_translation = { cash: 'наличные', cashless: 'безналичные' }
  status_translation = { not_paid: 'неоплачен', paid: 'оплачен' }

  filter :status, as: :select, collection: Payment.statuses.map { |p| [status_translation[p[0].to_sym], p[1]]}, label: "Статус"
  filter :payment_method, as: :select, collection: Payment.payment_methods.map { |p| [payment_method_translation[p[0].to_sym], p[1]]}, label: "Метод оплаты"

  permit_params :status

  index do
    column :description
    column :amount
    column :status do |payment|
      if payment.status == "not_paid"
        "Неоплачен"
      elsif payment.status == "paid"
        "Оплачен"
      end
    end
    column :payment_method do |payment|
      if payment.payment_method == "cash"
        "Наличные"
      elsif payment.payment_method == "cashless"
        "Безналичные"
      end
    end
    column :user
    column :order
    actions
  end

  show do
    attributes_table do
      row :description
      row :amount
      row :status do |payment|
        if payment.status == "not_paid"
          "Неоплачен"
        elsif payment.status == "paid"
          "Оплачен"
        end
      end
      row :payment_method do |payment|
        if payment.payment_method == "cash"
          "Наличные"
        elsif payment.payment_method == "cashless"
          "Безналичные"
        end
      end
      row :user
      row :order
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Payment.statuses.map { |p| [status_translation[p[0].to_sym], p[0]]}
    end
    f.actions
  end
end
