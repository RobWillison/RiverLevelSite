class River < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :river_datas

  index_name Rails.application.class.parent_name.underscore
  document_type self.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :river, analyzer: 'english'
      indexes :section, analyzer: 'english'
    end
  end

  scope :with_calibration, -> { where('level_indicators != "[]"') }
  scope :with_station, -> { where 'station IS NOT NULL' }

  def get_latest_reading
    result = river_datas.order(timestamp: :desc).limit(1)

    return -1 unless result[0]

    result[0]
  end

  def get_current_indicator
    return 'unknown' if get_latest_reading == -1
    level = get_latest_reading.river_level
    get_idicator(level)
  end

  def get_idicator(level)
    indicators = JSON.parse(level_indicators.gsub('\'', '"')).sort_by {|k, v| -v}
    indicators << ['empty', 0] if indicators.present?
    indicator = indicators.find { |i| i[1] < level }
    return -1 unless indicator
    indicator[0]
  end

  def get_level_indicators_with_color
    indicators = JSON.parse(level_indicators.gsub('\'', '"'))
    indicators.map { |key, value| {text: key, value: value, color: get_dot_color(key)}}
  end

  def as_indexed_json(options = nil)
    {
      id: id,
      river: river,
      section: section,
      lat: lat,
      long: long,
      current_indicator: get_current_indicator,
      dot_color: get_dot_color,
      predicted: has_prediction?
    }
  end

  def get_dot_color(level=get_current_indicator, colors: [])
    case level
    when 'empty'
      colors[0] || '#FF0000'
    when 'scrape'
      colors[1] || '#FF5721'
    when 'low'
      colors[2] || '#FFCC11'
    when 'medium'
      colors[3] || '#98FB98'
    when 'high'
      colors[4] || '#00FF00'
    when 'huge'
      colors[5] || '#228B22'
    else
      colors[6] || '#D3D3D3'
    end
  end

  def name
    river + ' - ' + section
  end

  def has_prediction?
    Prediction.where(river_id: id, live: 1).present?
  end

  def jobs?
    job = Job.where(call: "Predict.predict(#{id})")
    return job.present?
  end

  def enough_data_for_prediction?
    return station.present? && rain_radar_area_id.present? && source_agency == 'ea'
  end

  class << self

    def ready_to_predict
      River.all.select { |river| river.enough_data_for_prediction? && !river.jobs?}
    end

    def search(query)
      __elasticsearch__.search(
        {
          query:
          { multi_match:
            {
              query: query,
              fields: ['river', 'section'],
              fuzziness: "AUTO",
              operator:  "and",
            }
          }
        })
    end

    def es_get_all()
      __elasticsearch__.search(
        {
          size: 10000,
          query: {
            bool: {
              should: [
                { exists: { field: :lat } },
                { exists: { field: :long } },
                { exists: { field: :dot_color } }
              ],
              must_not: [
                {match: { current_indicator: -1 }}
              ],
              must: [
                { match: { predicted: true } }
              ]
            }
          }
        })
    end

    def index!
      all.each do |i|
        next unless i.has_prediction?
        i.__elasticsearch__.index_document
      end
    end

  end
end
