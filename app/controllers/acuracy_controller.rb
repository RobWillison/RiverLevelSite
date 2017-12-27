class AcuracyController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    @model_acuracy = []

    all_models = ModelConfig.where(default: 1).collect(&:models).flatten
    rivers = River.with_station
    rivers.each do |river|
      model_acuracy = Hash.new(0)
      models = all_models.select { |model| model.river_id == river.id }

      predictions = models.collect(&:predictions).flatten
      predictions.each do |prediction|
        next if prediction.acuracy_info.nil?
        acuracy_info = JSON.parse(prediction.acuracy_info)
        acuracy_info.each {|k, v| model_acuracy[k] += v}
        model_acuracy['total'] += 1
      end
      acuracies = model_acuracy.collect { |_k, v| (v / model_acuracy['total']).to_i }
      next if acuracies.empty?
      @model_acuracy << [river.id, river.name, model_acuracy['total'], acuracies]
    end
  end


  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
