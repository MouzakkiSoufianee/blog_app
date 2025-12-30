class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  authorize :user, through: :current_user

  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def authenticate_user!
    return if devise_controller?
    return if action_name.in?(%w[index show])
    super
  end
end
