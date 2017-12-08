class RiversController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    @rivers_data = JSON.load $redis.get("river-data-index")
    if @rivers_data.nil?
      rivers = River.all.reject { |r| !r.has_prediction? }
      @rivers_data = rivers.collect {|r| {
        'name' => r.name,
        'level' => r.get_latest_reading.river_level,
        'indicator' => r.get_current_indicator,
        'color' => r.get_dot_color,
        'url' => url_for(r)
        }}
      $redis.set("river-data-index", @rivers_data.to_json)
    end
  end

  def show
    @river = River.find(params[:id])
    config = ModelConfig.find_by(default: 1)
    @prediction = Prediction.joins(:model).where(models: {model_config_id: config.id, river_id: params[:id]}).order(id: :desc).first

    if @prediction
      @river_data = @prediction.get_prediction_data
      @river_data[:timestamps] = @river_data[:timestamps].map { |i| i.to_formatted_s(:db) }
    end

    @levels = @river.get_level_indicators_with_color.map {|i| {y: i[:value], text: i[:text], style: i[:color]}}
  end

  def history
    @river = River.find(params[:id])
    start_date = 7.days.ago
    end_date = Time.now.utc

    river_data = RiverData.where('time_string BETWEEN ? AND ?', start_date, end_date)
                            .where(river_id: @river.id).pluck(:time_string, :river_level)

    predictions = PredictedRiverLevel.joins(:prediction)
                                     .where('predict_time BETWEEN ? AND ?', start_date, end_date)
                                     .where(predictions: {river_id: @river.id})

    predicted_data = predictions.pluck(:predict_time, :river_level, :prediction_id)
    prediction_ids = predictions.pluck(:prediction_id).uniq

    @river_data = {}
    @river_data[:timestamps] = river_data.collect { |reading| reading[0] }
    @river_data[:real_levels] = river_data.collect { |reading| {x: reading[0], y: reading[1] }}
    @river_data[:predicted_level] = prediction_ids.collect do |pred_id|
      predicted_data.collect do |data|
        next if data[2] != pred_id
        {x: data[0], y: data[1]}
      end.reject(&:nil?)
    end
  end
end
