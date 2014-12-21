class StaticPagesController < ApplicationController
  skip_filter :ensure_authenticated, only: :about
  def about
  end
end
