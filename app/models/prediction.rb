class Prediction < ApplicationRecord

  def acuracy
    {
      hour1: acuracy_after_hours(1),
      hour12: acuracy_after_hours(12),
      hour24: acuracy_after_hours(24),
      hour48: acuracy_after_hours(48),
      day7: acuracy_after_hours(168)
    }
  end

  def acuracy_after_hours(hour)
    datetime = first_timestamp + hour.hours
    acuracy_at(datetime)
  end

  def first_timestamp
    sql = 'SELECT predict_time FROM predicted_river_levels WHERE prediction_id = ? ORDER BY predict_time ASC LIMIT 1'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(id)
    return nil if results_array.first == nil
    results_array.first[0]
  end

  def acuracy_at(datetime)
    sql = 'SELECT predicted_river_levels.predict_time,
                  predicted_river_levels.river_level,
                  river_data.river_level
           FROM `predicted_river_levels`
              INNER JOIN `river_data`
                ON `river_data`.`time_string` = `predicted_river_levels`.`predict_time`
                  AND `river_data`.`river_id` = `predicted_river_levels`.`river_id`
            WHERE predicted_river_levels.predict_time = ? AND predicted_river_levels.prediction_id = ?'

    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(datetime, id)

    return nil if results_array.first == nil
    (results_array.first[1] - results_array.first[2]).round(2)
  end

  def get_prediction_data
    sql = 'SELECT predict_time FROM predicted_river_levels WHERE prediction_id = ?'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(id)

    timestamps = results_array.to_a.flatten
    predicted_level = get_predicted_level(timestamps)
    
    {
      timestamps: timestamps,
      predicted_level: predicted_level,
    }
  end

  def get_river_data
    sql = 'SELECT predict_time FROM predicted_river_levels WHERE prediction_id = ?'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(id)

    timestamps = results_array.to_a.flatten
    real_levels = get_real_levels(timestamps)
    predicted_level = get_predicted_level(timestamps)
    rain_level = get_rain_levels(timestamps)
    {
      timestamps: timestamps,
      real_levels: real_levels,
      predicted_level: predicted_level,
      rain_level: rain_level
    }
  end

  def get_rain_levels(timestamps)
    timestamps.map {|timestamp| get_rain_level_for(timestamp)}
  end

  def get_rain_level_for(datetime)
    sql = 'SELECT rain_value FROM rain_forecast_data WHERE area_id = 811 ORDER BY  ABS(time_string - ?) ASC LIMIT 1'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(datetime)
    return 0 if results_array.first == nil
    results_array.first[0] / 1000
  end

  def get_real_levels(timestamps)
    timestamps.map {|timestamp| get_real_level_for(timestamp)}
  end

  def get_real_level_for(datetime)
    sql = 'SELECT river_level FROM river_data ORDER BY  ABS(time_string - ?) ASC LIMIT 1'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(datetime)
    if results_array.first == nil
      raise datetime.to_s
    end
    results_array.first[0]
  end

  def get_predicted_level(timestamps)
    timestamps.map {|timestamp| get_predicted_level_for(timestamp)}
  end

  def get_predicted_level_for(datetime)
    sql = 'SELECT river_level FROM predicted_river_levels WHERE predict_time = ? AND prediction_id = ?  LIMIT 1'
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(datetime, id)

    results_array.first[0]
  end
end
