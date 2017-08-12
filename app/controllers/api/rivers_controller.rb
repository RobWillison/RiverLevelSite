class Api::RiversController < ApplicationController
  def all
    rivers = River.all.pluck(:name, :lat, :long)
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
