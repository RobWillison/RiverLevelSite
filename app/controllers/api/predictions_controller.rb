class Api::PredictionsController < ApplicationController
  def all
    rivers = River.es_get_all
    data = {}
    river_data = rivers.map do |river|
      river = River.find(river.id)
      predict_data = JSON.load $redis.get("prediction#{river.id}")
      if predict_data.nil?
        config = ModelConfig.find_by(default: 1)
        prediction = Prediction.joins(:model).where(models: {model_config_id: config.id, river_id: river.id}).order(id: :desc).first
        predict_data = prediction.get_prediction_data

        $redis.set("prediction#{river.id}", predict_data.to_json)
      end
      predict_data = predict_data.with_indifferent_access

      predict_data[:dot_color] = predict_data[:predicted_level]
                                  .map { |level| river.get_dot_color(river.get_idicator(level))}

      data[river.id] = predict_data[:timestamps].zip(predict_data[:dot_color])
    end

    render :json => data
  end
end