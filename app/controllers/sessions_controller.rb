class SessionsController < ApplicationController
  def create
    warden.authenticate!
    redirect_to root_path
  end
end
