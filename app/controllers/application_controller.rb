class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [ :name ]
    )
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  # IMPORTANT for Confirmable
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def user_not_authorized
      redirect_back(
        fallback_location: root_path,
        alert: "You are not authorized to perform this action."
      )
  end
end
