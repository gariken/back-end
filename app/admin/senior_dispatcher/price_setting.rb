# ActiveAdmin.register PriceSetting do
#   menu :url => '/admin/price_settings/1'
#   actions :index, :show, :edit, :update

#   permit_params :waiting_price, :price_per_kilometer, :percentage_of_driver, :free_waiting_minutes,
#                 :driver_rate_increase_by_orders, :driver_rate_increase_by_rating, :max_driver_rate,
#                 :coef_for_comfort, :coef_for_economy, :driver_rate_increase_by_photo, :min_order_amount

#   index do
#     selectable_column
#     column :waiting_price
#     column :price_per_kilometer
#     column :percentage_of_driver
#     column :free_waiting_minutes
#     column :driver_rate_increase_by_orders
#     column :driver_rate_increase_by_rating
#     column :max_driver_rate
#     column :coef_for_economy
#     column :coef_for_comfort
#     column :updated_at
#     actions
#   end

#   show do
#     attributes_table do
#       row :min_order_amount
#       row :price_per_kilometer
#       row :waiting_price
#       row :free_waiting_minutes
#       row :percentage_of_driver
#       row :driver_rate_increase_by_orders
#       row :driver_rate_increase_by_rating
#       row :driver_rate_increase_by_photo
#       row :max_driver_rate
#       row :coef_for_economy
#       row :coef_for_comfort
#       row :updated_at
#     end
#   end

#   form do |f|
#     f.inputs do
#       f.input :min_order_amount
#       f.input :price_per_kilometer
#       f.input :waiting_price
#       f.input :free_waiting_minutes
#       f.input :percentage_of_driver
#       f.input :driver_rate_increase_by_orders
#       f.input :driver_rate_increase_by_rating
#       f.input :driver_rate_increase_by_photo
#       f.input :max_driver_rate
#       f.input :coef_for_economy
#       f.input :coef_for_comfort
#     end
#     f.actions
#   end
# end
