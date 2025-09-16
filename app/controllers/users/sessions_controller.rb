# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      user.update(role: params[:role]) if params[:role].present?
    end
  end
  protected

def after_sign_in_path_for(resource)
  case resource.role
  when "owner"
    owner_dashboard_path
  when "renter"
    renter_dashboard_path
  else
    root_path
  end
end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
