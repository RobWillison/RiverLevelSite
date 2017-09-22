class RiversController < ApplicationController
  def index
    @rivers = River.all
  end

  def show
    @river = River.find(params[:id])
    @prediction = Prediction.where(river_id: params[:id]).order('created_at DESC').first

    @river_data = @prediction.get_prediction_data
    @river_data[:timestamps] = @river_data[:timestamps].map { |i| i.to_formatted_s(:db) }
  end
end
