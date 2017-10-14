class Job < ApplicationRecord
  def duration
    return 'None' if !last_run || !last_start_time
    return 'Running' if last_start_time && last_run && last_start_time > last_run
    return last_run - last_start_time
  end
end
