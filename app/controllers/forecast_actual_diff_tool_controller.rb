class ForecastActualDiffToolController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin!

  def index
    gatherer = Gatherer.find(1)
    latest_time = gatherer.latest_record[2]

    @actual_results = gatherer.get_datetime_array(latest_time)
    @actual_results = @actual_results.map {|i| {area: i[4],rain: (i[3] / 100.0).to_i}}

    gatherer = Gatherer.find(2)
    @forecast_results = gatherer.get_datetime_array(latest_time)
    @forecast_results = @forecast_results.map {|i| {area: i[4],rain: (i[3] / 100.0).to_i}}
  end

  def show

  end

  def check_admin!
    redirect_to root_path unless current_user.admin?
  end
end
