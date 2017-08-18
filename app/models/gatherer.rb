class Gatherer < ApplicationRecord

  def latest_record
    sql = "SELECT * FROM #{self.results_table} ORDER BY time_string DESC LIMIT 1"
    records_array = ActiveRecord::Base.connection.execute(sql)

    return records_array.first
  end
end
