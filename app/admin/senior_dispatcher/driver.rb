ActiveAdmin.register Driver, namespace: :senior_dispatcher do
  actions :index, :show, :destroy, :edit, :update, :create, :new

  config.current_filters = false
  preserve_default_filters!

  remove_filter :balance
  remove_filter :password
  remove_filter :encrypted_password
  remove_filter :license
  remove_filter :photo
  remove_filter :points
  remove_filter :bonus_on_this_week
  remove_filter :orders

  filter :name
  filter :surname
  filter :status, as: :select, collection: Driver.statuses, label: "Статус"

  permit_params :name, :surname, :phone_number, :password, :encrypted_password, :licence_plate, :photo, :car_model,
                :balance, :license, :points, :confirmed, :rating, :status, :tariff_id, :car_color

  member_action :remove_photo, method: :put do
    resource.remove_photo!
    resource.update(photo: nil)
    redirect_to resource_path, notice: "Фото удалено"
  end

  member_action :remove_license, method: :put do
    resource.remove_license!
    resource.update(license: nil)
    redirect_to resource_path, notice: "Права удалены"
  end

  action_item only: :show do
    link_to 'Удалить фото', "/senior_dispatcher/drivers/#{driver.id}/remove_photo", method: :put, data: { confirm: 'Вы уверены, что хотите удалить фото?' }
  end

  action_item only: :show do
    link_to 'Удалить права', "/senior_dispatcher/drivers/#{driver.id}/remove_license", method: :put, data: { confirm: 'Вы уверены, что хотите удалить права?' }
  end

  index do
    column :phone_number
    column :name
    column :surname
    column :car_model
    column :car_color
    column :licence_plate
    column :tariff_id do |driver|
      tariff = driver.tariff
      driver.tariff_id.nil? ? '' : link_to("#{tariff.name}", "/senior_dispatcher/tariffs/#{tariff.id}")
    end
    column :confirmed
    column :rating
    actions
 end

  show do
    attributes_table do
      row :id
      row :status
      row :name
      row :surname
      row :phone_number
      unless resource.photo.blank?
        row :photo do |driver|
          image_tag driver.photo.url
        end
      else
        row :photo
      end
      unless resource.license.blank?
        row :license do |driver|
          image_tag driver.license.url
        end
      else
        row :license
      end
      row :licence_plate
      row :car_model
      row :car_color
      row :tariff_id do |driver|
        tariff = driver.tariff
        driver.tariff_id.nil? ? '' : link_to("#{tariff.name}", "/senior_dispatcher/tariffs/#{tariff.id}")
      end
      row :balance
      row :points
      row :rating
      row :confirmed
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :surname
      f.input :phone_number
      f.input :licence_plate
      f.input :photo
      f.input :car_model
      f.input :license
      f.input :car_color, as: :string
      f.input :status
      f.input :points
      f.input :balance
      f.input :tariff_id, input_html: { style: 'width:12%'}, as: :select, collection: Tariff.where(status: 'active').map { |t| ["#{t.name}", t.id] }
      f.input :confirmed
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
      params[:driver][:phone_number] = Phony.normalize(params[:driver][:phone_number].gsub(/[^0-9]/, "").gsub(/^8/, "7")) if !params[:driver][:phone_number].blank?
      params[:driver][:password] = Random.new.rand(111111..999999)
      params[:driver][:surname] = params[:driver][:surname].capitalize
      params[:driver][:name] = params[:driver][:name].capitalize
      params[:driver][:licence_plate] = params[:driver][:licence_plate].upcase
      params[:driver][:balance] = 100
      params[:driver][:points] = 0
      params[:driver][:rating] = 0
      create!
    end

    def destroy
      resource.update(status: 'inactive')
      redirect_to action: :index
    end

    def update
      resource.remove_photo! unless params[:driver][:photo].nil?
      resource.remove_license! unless params[:driver][:license].nil?
      if resource.update(permitted_params[:driver])
        redirect_to resource_path
      else
        render :edit
      end
    end
  end
end
