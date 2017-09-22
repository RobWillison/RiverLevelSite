class Api::RiversController < ApplicationController
  def all
    rivers = River.where('`lat` IS NOT NULL AND `long` IS NOT NULL').limit(10).pluck(:id, :lat, :long)

    render :json => rivers
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
