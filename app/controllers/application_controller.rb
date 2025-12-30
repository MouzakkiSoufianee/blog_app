class ApplicationController < ActionController::Base
  include ActionPolicy::Behaviour

  allow_browser versions: :modern

  authorize :user, through: :current_user

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # WHY: Permit custom Devise fields (name and role) beyond default email/password
  # WHAT: name - User's full name for display
  #       role - Authorization level (member, admin)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :role ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :role ])
  end

  def authenticate_user!
    return if devise_controller?
    return if action_name.in?(%w[index show])
    super
  end
end
