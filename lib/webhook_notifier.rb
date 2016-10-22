class WebhookNotifier
  def initialize(endpoint, tweets)
    @endpoint, @tweets = URI.parse(endpoint), tweets
  end

  def post
    request = Net::HTTP::Post.new(@endpoint.request_uri, 'Content-Type' => 'application/json')
    request.body = {
      tweets: @tweets,
      tweets_html: tweets_html,
    }.to_json
    Net::HTTP.new(@endpoint.host, @endpoint.port).request(request)
  end

  private

  def tweets_html
    @tweets.map do |tweet|
      "<p>#{tweet[:username]}: <a href=\"#{tweet[:url]}\">#{tweet[:text]}</a></p>"
    end.join("\n")
  end
end
