class Api::RiversController < ApplicationController
  def all
    rivers = River.es_get_all

    river_data = rivers.map do |river|
      {id: river.id, lat: river.lat, long: river.long, color: river.dot_color}
    end

    render :json => river_data
  end

  def search
    term = params['term'] || ''
    results = River.search(term)
    rivers = results.collect do |i|
      {id: i.id, text: i[:_source][:river] + ' - ' + i[:_source][:section]}
    end

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
