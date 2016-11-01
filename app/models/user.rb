class User < ApplicationRecord
  has_many :roundups

  after_create { Count.increment(:user) }
end
