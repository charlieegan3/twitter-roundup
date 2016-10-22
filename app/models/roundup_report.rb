class RoundupReport < ApplicationRecord
  belongs_to :roundup

  serialize :tweets, Array

  def empty?
    self.tweets.empty?
  end
end
