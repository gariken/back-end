ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    columns do

      column do
        panel "Последние заказы" do
          ul do
            Order.order(created_at: 'desc')[0..5].map do |order|
              li link_to("#{order.address_from} - #{order.address_to}", admin_order_path(order))
            end
          end
        end
      end

      column do
        panel "Последние водители" do
          ul do
            Driver.order(created_at: 'desc')[0..5].map do |driver|
              li link_to("#{driver.surname} #{driver.name}", admin_driver_path(driver))
            end
          end
        end

      end

    end
  end
end
