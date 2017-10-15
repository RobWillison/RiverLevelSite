class Job < ApplicationRecord
  def duration
    return 'None' if !last_run || !last_start_time
    return 'Running' if running?
    return last_run - last_start_time
  end

  def running?
    last_start_time && last_run && last_start_time > last_run
  end
end
