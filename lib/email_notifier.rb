class EmailNotifier
  def initialize(email, tweets)
    @email, @tweets = email, tweets
    @client = Postmark::ApiClient.new(ENV['POSTMARK_API_TOKEN'])
  end

  def send
    @client.deliver(
      from: 'me@charlieegan3.com',
      to: @email,
      subject: "Roundup: #{tweet_usernames}",
      html_body: tweets_html,
    )
  end

  private

  def tweet_usernames
    @tweets.map { |t| t[:username] }.uniq.join(', ')
  end

  def tweets_html
    (@tweets.map { |tweet|
      "<p>#{tweet[:username]}: <a href=\"#{tweet[:url]}\">#{tweet[:text]}</a></p>"
    } + [link_html]).join("\n")
  end

  def link_html
    "<hr/><p>Edit settings at <a href=\"https://twitter-roundup.herokuapp.com\">https://twitter-roundup.herokuapp.com</a></p>"
  end
end
