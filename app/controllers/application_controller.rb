class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Role-based access control
  def require_renter
    unless current_user&.role == "renter"
      redirect_to root_path, alert: "Access denied."
    end
  end

  def require_owner
    unless current_user&.role == "owner"
      redirect_to root_path, alert: "Access denied."
    end
  end

  protected

  # Permit extra fields for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number, :role])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:role])
  end

  # Redirect after login
  def after_sign_in_path_for(resource)
    case resource.role
    when "owner"
      owner_dashboard_path
    when "user"
      renter_dashboard_path
    else
      root_path
    end
  end

  # Redirect after sign-up
  def after_sign_up_path_for(resource)
    resource.role == "owner" ? dashboard_path : cars_path
  end

  # Redirect after logout
  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end
end
