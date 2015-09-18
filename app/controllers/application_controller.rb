class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception

  before_action :configure_permitted_parameters, :if => :devise_controller?

  protected

  # Permit additional devise user parameters.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username) }
    devise_parameter_sanitizer.for(:edit_user) { |u| u.permit(:username, :email) }
  end

  # For use with Devise.
  def require_admin
    unless current_user && current_user.admin
      flash[:alert] = "You must sign in to view this page"
      redirect_to new_user_session_path
    end
  end
end
