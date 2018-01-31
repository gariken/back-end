class ApplicationController < ActionController::Base
  def authenticate_any_admin_user!
    if current_senior_dispatcher_admin_user && request.path.split("/")[1] != "senior_dispatcher"
      redirect_to "/senior_dispatcher"
    elsif current_dispatcher_admin_user && request.path.split("/")[1] != "dispatcher"
      redirect_to "/dispatcher"
    elsif current_admin_user && request.path.split("/")[1] != "admin"
      redirect_to "/admin"
    elsif current_admin_user.nil? && current_senior_dispatcher_admin_user.nil? && current_dispatcher_admin_user.nil?
      if request.path.split("/")[1] == "senior_dispatcher"
        redirect_to new_senior_dispatcher_admin_user_session_path
      elsif request.path.split("/")[1] == "dispatcher"
        redirect_to new_dispatcher_admin_user_session_path
      elsif request.path.split("/")[1] == "admin"
        redirect_to new_admin_user_session_path
      end
    end
  end
end
