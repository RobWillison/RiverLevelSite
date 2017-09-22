class Api::RiversController < ApplicationController
  def all
    rivers = River.where('`lat` IS NOT NULL AND `long` IS NOT NULL').limit(10).pluck(:id, :lat, :long)

    render :json => rivers
  end

  def autocomplete
    rivers = River.all.map do |river|
      {
        name: river.name,
      }
    end

    render json: rivers
  end
end
