#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @roundup.list_of_monitored_accounts.join(", ")
    xml.author "Twitter Roundup"
    xml.description "Twitter Roundup of #{@roundup.list_of_monitored_accounts.join(", ")}"
    xml.link "#{request.protocol}#{request.host_with_port}/roundups/#{@roundup.id}"
    xml.language "en"

    @roundup.roundup_reports.order(created_at: :desc).each do |report|
      xml.item do
        xml.title "Report #{report.id}"
        xml.author "Twitter Roundup"
        xml.pubDate report.created_at.to_s(:rfc822)
        xml.link "todo"
        xml.link "#{request.protocol}#{request.host_with_port}/roundups/#{@roundup.id}#report-#{report.id}"
        xml.guid report.id

        xml.description(
          report.tweets.map do |tweet|
            text = tweet[:text].blank? ? "blank" : tweet[:text]
            "<p>#{tweet[:username]}: <a href=\"#{tweet[:url]}\">#{text}</a></p>"
          end.join("\n")
        )
      end
    end
  end
end
