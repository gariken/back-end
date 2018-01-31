ActiveAdmin.register OrderOption, namespace: :dispatcher do
  actions :index, :show

  before_action :skip_sidebar!, :only => :index

  config.sort_order = 'status_asc'

  permit_params :description, :price, :status

  index do
    column :description
    column :price
    column :status
    actions
  end
end
