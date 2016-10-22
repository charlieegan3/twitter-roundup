class TwitterCollector
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
    end
  end

  def build_roundup_for(users, from_time)
    [].tap do |formatted_tweets|
      users.each do |user|
        tweets = @client.user_timeline(user, exclude_replies: true, include_rts: true, trim_user: true, count: 200)
        tweets.select! { |t| t.created_at > from_time && t.urls? }

        tweets.each do |t|
          text = t.text.gsub(/https?\S+/, "").strip
          url = t.urls.map(&:url).map(&:to_s).first
          formatted_tweets << { username: user, text: text, url: url }
        end
      end
    end
  end
end
