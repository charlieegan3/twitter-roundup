class RoundupReport < ApplicationRecord
  belongs_to :roundup

  serialize :tweets, Array

  after_create { Count.increment(:roundup_report) }

  def empty?
    self.tweets.empty?
  end
end
