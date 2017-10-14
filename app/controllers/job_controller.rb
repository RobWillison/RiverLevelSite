class JobController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @jobs = Job.all
  end

  def create
    river_id = params['river']
    Job.create!(call: "TrainingData.updateRiver(#{river_id})", run_frequency: 2, priority: 10)
    Job.create!(call: "Model.train(#{river_id})", run_frequency: 2, priority: 20)
    Job.create!(call: "Predict.predict(#{river_id})", run_frequency: 1, priority: 30)
  end

  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
