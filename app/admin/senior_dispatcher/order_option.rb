ActiveAdmin.register OrderOption, namespace: :senior_dispatcher do
  before_action :skip_sidebar!, :only => :index

  config.sort_order = 'status_asc'

  permit_params :description, :price, :status

  index do
    column :description
    column :price
    column :status
    actions
  end

  controller do
    def destroy
      resource.update(status: 'inactive')
      redirect_to action: :index
    end
  end
end
