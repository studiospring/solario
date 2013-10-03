class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected
    #permit additional devise user parameters
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :admin, :password) }
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :admin, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:edit_user) { |u| u.permit(:username, :email, :admin, :password, :password_confirmation) }
    end

    #for use with Devise
    def require_admin
      unless current_user && current_user.admin
        flash[:error] = "You are not an admin"
        redirect_to root_path
      end        
    end
end
