class AcuracyController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @model_acuracy = []

    configs = ModelConfig.all
    configs.each do |config|
      models = config.models
      model_acuracy = Hash.new(0)
      predictions = models.collect(&:predictions).flatten
      predictions.each do |prediction|
        next if prediction.acuracy_info.nil?
        acuracy_info = JSON.load(prediction.acuracy_info)
        acuracy_info.each {|k, v| model_acuracy[k] += v}
        model_acuracy['total'] += 1
      end
      acuracies = model_acuracy.collect { |k, v| (v / model_acuracy['total']).to_i}
      @model_acuracy << [config, model_acuracy['total'], acuracies]
    end
  end


  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
