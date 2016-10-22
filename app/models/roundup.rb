class Roundup < ApplicationRecord
  belongs_to :user
  has_many :roundup_reports, dependent: :destroy

  after_save :schedule_job
  before_destroy :remove_job

  def schedule_job(run_at=period.from_now)
    remove_job
    new_job = Delayed::Job.enqueue({
      payload_object: Delayed::PerformableMethod.new(self, :refresh, []),
      priority: 10,
      run_at: run_at,
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
    roundup_reports.create(
      tweets: TwitterCollector.new.build_roundup_for(list_of_monitored_accounts, period.ago))
    schedule_job
  end

  def list_of_monitored_accounts
    self.monitored_accounts.scan(/(?:@|^)(\S+)/).flatten
  end

  def manually_refreshable?
    if Time.zone.now - self.created_at < 5.minutes
      true
    elsif job.present?
      Time.zone.now - self.scheduled_at > 5.minutes
    else
      true
    end
  end

  def manually_refreshable_in
    5.minutes - (Time.zone.now - self.scheduled_at)
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
