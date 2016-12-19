task :count_init => :environment do
  [:user, :roundup, :roundup_report].each do |key|
    count = Count.find_or_create_by(key: key)
    count.update_attribute(:value, 0)
  end
end
