class TwitterCollector
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def build_roundup_for(users, from_time, whitelist, blacklist, links_only, include_retweets)
    [].tap do |formatted_tweets|
      users.take(Rails.configuration.roundup_account_limit).each do |user|
        begin
          tweets = @client.user_timeline(user, exclude_replies: true, include_rts: true, trim_user: true, count: 100)
        rescue Twitter::Error => e
          Rollbar.error(e)
          next
        end

        tweets.select! { |t| t.created_at > from_time }
        tweets.select! { |t| t.urls? } if links_only == true
        tweets.reject! { |t| t.retweet? } if include_retweets == false
        tweets.select! { |t| whitelist.any? { |e| t.text.downcase.include? e.downcase } } unless whitelist.empty?
        tweets.reject! { |t| blacklist.any? { |e| t.text.downcase.include? e.downcase } } unless blacklist.empty?

        tweets.uniq! { |t| t.text.gsub(/https?\S+/, "") }

        tweets.each do |t|
          text = t.text.gsub(/https?\S+/, "").strip
          url = t.urls.map(&:url).map(&:to_s).first
          formatted_tweets << { username: user, text: text, url: url }
        end
      end
    end
  end
end
