class GatherersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @gatherers = Gatherer.all
  end

  def show
    @gatherer = Gatherer.find(params[:id])
  end

  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
