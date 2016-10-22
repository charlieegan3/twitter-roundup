class Roundup < ApplicationRecord
  belongs_to :user

  after_save :schedule_job
  before_destroy :remove_job

  def schedule_job
    remove_job
    new_job = Delayed::Job.enqueue({
      payload_object: Delayed::PerformableMethod.new(self, :refresh, []),
      priority: 10,
      run_at: period.from_now,
    })
    update_columns(delayed_job_id: new_job.id, scheduled_at: Time.zone.now)
  end

  def remove_job
    job.destroy if job
  end

  def job
    Delayed::Job.find_by_id(self.delayed_job_id)
  end

  def refresh
    tweets = TwitterCollector.new.build_roundup_for(list_of_monitored_accounts, period.ago)
    puts tweets
    schedule_job
  end

  def list_of_monitored_accounts
    self.monitored_accounts.scan(/(?:@|^)(\S+)/).flatten
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
end
