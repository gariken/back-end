ActiveAdmin.register User, namespace: :dispatcher do
  actions :index, :show

  config.current_filters = false
  preserve_default_filters!

  remove_filter :password
  remove_filter :encrypted_password
  remove_filter :photo
  remove_filter :orders
  remove_filter :addresses
  remove_filter :payments
  remove_filter :favorite_addresses
  remove_filter :email
  remove_filter :payments_token
  remove_filter :card_is_binded

  filter :status, as: :select, collection: User.statuses, label: "Статус"

  permit_params :name, :surname, :sex, :phone_number, :password, :encrypted_password, :status

  index do
    column :phone_number
    column :name
    column :surname
    column :sex
    actions
  end

  show do
    attributes_table do
      row :id
      row :status
      row :name
      row :surname
      row :sex
      row :phone_number
      unless resource.photo.blank?
        row :photo do |user|
          image_tag user.photo.url
        end
      else
        row :photo
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :status
      f.input :name
      f.input :surname
      f.input :phone_number
      f.input :sex
      f.input :photo
    end
    f.actions
  end

  controller do
    before_action only: :index do
      if params[:commit].blank? && params[:q].blank?
        extra_params = { "q": { "status_eq": "0" } }
        params.merge! extra_params
      end
    end

    def create
      params[:user][:password] = Random.new.rand(111111..999999)
      create!
    end
  end
end
