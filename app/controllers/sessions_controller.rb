class SessionsController < ApplicationController
  skip_filter :ensure_authenticated, only: :create
  def create
    warden.authenticate!
    redirect_to root_path
  end

  def destroy
    warden.logout
    redirect_to root_path
  end
end
