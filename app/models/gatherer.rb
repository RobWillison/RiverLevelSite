class Gatherer < ApplicationRecord

  def latest_record
    sql = "SELECT * FROM #{self.results_table} ORDER BY time_string DESC LIMIT 1"
    records_array = ActiveRecord::Base.connection.execute(sql)

    return records_array.first
  end

  def get_datetime_array(datetime)
    sql = "SELECT * FROM #{self.results_table} WHERE time_string = ?"
    query = ActiveRecord::Base.connection.raw_connection.prepare(sql)
    results_array = query.execute(datetime)
    return results_array

  end
end
