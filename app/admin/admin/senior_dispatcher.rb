ActiveAdmin.register SeniorDispatcherAdminUser do
  before_action :skip_sidebar!, :only => :index

  permit_params :email, :password, :password_confirmation, :encrypted_password

  show do
    attributes_table do
      row :email
      row :current_sign_in_at
    end
  end

  index do
    column :email
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
