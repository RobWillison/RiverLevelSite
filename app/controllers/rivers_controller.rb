class RiversController < ApplicationController
  def index
    @rivers = River.all
  end

  def show
    @river = River.find(params[:id])
    @prediction = Prediction.where(river_id: params[:id]).order('created_at DESC').first
    if @prediction
      @river_data = @prediction.get_prediction_data
      @river_data[:timestamps] = @river_data[:timestamps].map { |i| i.to_formatted_s(:db) }
    end

    @levels = @river.get_level_indicators_with_color.map {|i| {y: i[:value], text: i[:text], style: i[:color]}}
  end
end
