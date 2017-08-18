class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!
  def index

  end

  def show

  end

  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
