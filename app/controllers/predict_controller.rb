class PredictController < ApplicationController
  def index
    predictions = PredictedRiverLevel.group(:created_at).pluck(:created_at)

  end

  def show

  end
end
