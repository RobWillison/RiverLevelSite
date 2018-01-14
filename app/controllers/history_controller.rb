class HistoryController < ApplicationController
  include Rails.application.routes.url_helpers

  def show
    @river = River.find(params[:river_id])

    predictions = Prediction.find(params[:id]).predicted_river_levels

    river_data = RiverData.where('time_string BETWEEN ? AND ?', predictions.first.predict_time, predictions.last.predict_time)
                            .where(river_id: @river.id).pluck(:time_string, :river_level)



    @river_data = {}
    @river_data[:timestamps] = river_data.collect { |reading| reading[0] }
    @river_data[:real_levels] = river_data.collect { |reading| {x: reading[0], y: reading[1] }}
    @river_data[:predicted_level] = predictions.collect { |reading| {x: reading.predict_time, y: reading.river_level }}

  end
end
