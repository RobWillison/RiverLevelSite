class Api::PredictionsController < ApplicationController
  def all
    rivers = River.es_get_all
    data = {}
    river_data = rivers.map do |river|
      river = River.find(river.id)
      predict_data = JSON.load $redis.get("prediction#{river.id}")
      if predict_data.nil?
        prediction = Prediction.order(created_at: :desc).where(river_id: river.id).limit(1).first
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