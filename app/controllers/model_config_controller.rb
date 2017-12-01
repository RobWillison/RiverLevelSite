class ModelConfigController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @configs = ModelConfig.all
  end

  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
