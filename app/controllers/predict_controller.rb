class PredictController < ApplicationController
  def index
    @predictions = Prediction.order(:created_at)
  end

  def show
    @prediction = Prediction.find(params[:id])

    @river_data = @prediction.get_river_data
  end
end
