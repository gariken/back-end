ActiveAdmin.setup do |config|
  config.site_title = "Taxi"

  config.comments = false

  config.comments_menu = false

  config.batch_actions = true

  config.localize_format = :long

  config.footer = "Eskar.Admin"

  config.csv_options = { col_sep: ';' }

  config.namespace :admin do |admin|
    config.authentication_method = :authenticate_admin_user!
    config.current_user_method = :current_admin_user
    config.logout_link_path = :destroy_admin_user_session_path
    admin.build_menu do |menu|
      menu.add label: "Выйти", url: :destroy_admin_user_session_path, priority: 1000
    end
  end

  config.namespace :dispatcher do |dispatcher|
    config.authentication_method = :authenticate_dispatcher_admin_user!
    config.current_user_method = :current_dispatcher_admin_user
    config.logout_link_path = :destroy_dispatcher_admin_user_session_path
    dispatcher.build_menu do |menu|
      menu.add label: "Выйти", url: :destroy_dispatcher_admin_user_session_path, priority: 1000
    end
  end

  config.namespace :senior_dispatcher do |senior_dispatcher|
    config.authentication_method = :authenticate_senior_dispatcher_admin_user!
    config.current_user_method = :current_senior_dispatcher_admin_user
    config.logout_link_path = :destroy_senior_dispatcher_admin_user_session_path
    senior_dispatcher.build_menu do |menu|
      menu.add label: "Выйти", url: :destroy_senior_dispatcher_admin_user_session_path, priority: 1000
    end
  end
end

ActiveAdmin::BaseController.class_eval do
  skip_before_action :authenticate_active_admin_user
  before_action :authenticate_any_admin_user!
end

class ActiveAdmin::Devise::SessionsController
  before_action :check_admin_login_path, if: -> { current_admin_user || current_senior_dispatcher_admin_user || current_dispatcher_admin_user }

  def destroy
    if current_dispatcher_admin_user
      sign_out current_dispatcher_admin_user
      redirect_to new_dispatcher_admin_user_session_path
    elsif current_senior_dispatcher_admin_user
      sign_out current_senior_dispatcher_admin_user
      redirect_to new_senior_dispatcher_admin_user_session_path
    elsif current_admin_user
      sign_out current_admin_user
      redirect_to new_admin_user_session_path
    end
  end

  def after_sign_in_path_for(resource)
    if current_dispatcher_admin_user
      "/dispatcher"
    elsif current_senior_dispatcher_admin_user
      "/senior_dispatcher"
    elsif current_admin_user
      "/admin"
    end
  end

  def check_admin_login_path
    if current_senior_dispatcher_admin_user && request.path.split("/")[1] != "senior_dispatcher"
      redirect_to "/senior_dispatcher"
    elsif current_dispatcher_admin_user && request.path.split("/")[1] != "dispatcher"
      redirect_to "/dispatcher"
    elsif current_admin_user && request.path.split("/")[1] != "admin"
      redirect_to "/admin"
    end
  end
end
