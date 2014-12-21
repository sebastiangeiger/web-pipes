class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :ensure_authenticated

  def current_user
    warden.user
  end
  helper_method :current_user

  def ensure_authenticated
    redirect_to about_path unless current_user.present?
  end

  def warden
    env['warden']
  end
end
