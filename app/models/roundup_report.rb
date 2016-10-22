class RoundupReport < ApplicationRecord
  belongs_to :roundup

  serialize :tweets, Array
end
