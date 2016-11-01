class Count < ApplicationRecord
  def self.increment(type)
    count = find_or_create_by(key: type)
    count.update_attribute(:value, (count.value || 0) + 1)
  end
end
