class Roundup < ApplicationRecord
  belongs_to :user

  after_save :schedule_job

  def schedule_job
    job.destroy if job
    new_job = Delayed::Job.enqueue({
      payload_object: Delayed::PerformableMethod.new(self, :refresh, []),
      priority: 10,
      run_at: period.from_now,
    })
    update_columns(delayed_job_id: new_job.id, scheduled_at: Time.zone.now)
  end

  def job
    Delayed::Job.find_by_id(self.delayed_job_id)
  end

  def refresh
    puts "Refreshed"
    puts self.inspect
    schedule_job
  end

  def period
    case self.frequency
    when 0
      1.day
    when 1
      1.week
    else
      1.week
    end
  end

  def self.frequencies
    [['Daily', 0], ['Weekly', 1]]
  end
end
