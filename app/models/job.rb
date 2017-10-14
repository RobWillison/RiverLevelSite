class Job < ApplicationRecord
  def duration
    return 'Running' if last_start_time > last_run
    return last_run - last_start_time
  end
end
