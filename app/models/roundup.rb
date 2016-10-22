class Roundup < ApplicationRecord
  belongs_to :user

  def self.frequencies
    [['Daily', 0], ['Weekly', 1]]
  end
end
