ActiveAdmin.register User do
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

  permit_params :name, :surname, :sex, :phone_number, :password, :encrypted_password, :status, :photo

  member_action :remove_photo, method: :put do
    resource.remove_photo!
    resource.update(photo: nil)
    redirect_to resource_path, notice: "Фото удалено"
  end

  action_item only: :show do
    link_to 'Удалить фото', "/admin/users/#{user.id}/remove_photo", method: :put, data: { confirm: 'Вы уверены, что хотите удалить фото?' }
  end

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
      params[:user][:phone_number] = Phony.normalize(params[:user][:phone_number].gsub(/[^0-9]/, "").gsub(/^8/, "7"))
      params[:user][:password] = Random.new.rand(111111..999999)
      create!
    end

    def destroy
      resource.update(status: 'inactive')
      redirect_to action: :index
    end

    def update
      resource.remove_photo! unless params[:user][:photo].nil?
      if resource.update(permitted_params[:user])
        redirect_to resource_path
      else
        render :edit
      end
    end
  end
end
