ActiveAdmin.register Tariff, namespace: :senior_dispatcher do
  actions :index, :show, :edit, :update

  before_action :skip_sidebar!, :only => :index

  permit_params :waiting_price, :price_per_kilometer, :percentage_of_driver, :free_waiting_minutes,
                :driver_rate_increase_by_orders, :driver_rate_increase_by_rating, :max_driver_rate,
                :driver_rate_increase_by_photo, :min_order_amount, :name, :position, :priority

  index do
    column :name
    column :position
    column :priority
    column :price_per_kilometer
    column :min_order_amount
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :status
      row :priority
      row :position
      row :price_per_kilometer
      row :night_price_per_kilometer
      row :min_order_amount
      row :waiting_price
      row :free_waiting_minutes
      row :percentage_of_driver
      row :max_driver_rate
      row :driver_rate_increase_by_orders
      row :driver_rate_increase_by_rating
      row :driver_rate_increase_by_photo
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
