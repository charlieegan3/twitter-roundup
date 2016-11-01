class Roundup < ApplicationRecord
  belongs_to :user
  has_many :roundup_reports, dependent: :destroy

  before_destroy :remove_job

  after_create { Count.increment(:roundup) }

  REFRESH_TIME = 2.minutes

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
    report = roundup_reports.create(
      tweets: TwitterCollector.new.build_roundup_for(*twitter_collection_args)
    )
    send_notifications unless report.empty?
    schedule_job
  end

  def twitter_collection_args
    [
      list_of_monitored_accounts,
      period.ago,
      format_list(self.whitelist),
      format_list(self.blacklist),
      self.links_only,
      self.include_retweets
    ]
  end

  def list_of_monitored_accounts
    self.monitored_accounts.scan(/(?:@|^)(\S+)/).flatten.uniq
  end

  def manually_refreshable?
    if job.present?
      Time.zone.now - self.scheduled_at > REFRESH_TIME
    else
      true
    end
  end

  def manually_refreshable_in
    REFRESH_TIME - (Time.zone.now - self.scheduled_at)
  end

  def send_notifications
    if self.webhook_endpoint.present?
      WebhookNotifier.new(self.webhook_endpoint, self.roundup_reports.last.tweets).post
    end
    if self.email_address.present?
      EmailNotifier.new(self.email_address, self.roundup_reports.last.tweets).send
    end
  end

  def format_list(list)
    list.nil? ? [] : list.split(/\W+/)
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
