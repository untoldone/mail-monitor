require "gmail"
require "twilio-ruby"
require "rufus-scheduler"

# monkey patch given bug https://github.com/gmailgem/gmail/issues/228
class Object
  def to_imap_date
    date = respond_to?(:utc) ? utc.to_s : to_s
    Date.parse(date).strftime('%d-%b-%Y')
  end
end

def check
  gmail = Gmail.connect(ENV["GMAIL_USER"], ENV["GMAIL_PASS"])
  twilio = Twilio::REST::Client.new ENV["ACCOUNT_SID"], ENV["AUTH_TOKEN"]

  now = Time.now
  aged = now - (16 * 60 * 60) # 16 hours ago

  count = gmail.inbox.count(:unread, before: aged)

  puts "Found #{count} unread emails within last 16 hours"

  if count > 0
    twilio.messages.create(
      from: '+14156501913',
      to: '+12409947981',
      body: "You have #{count} unread emails older than 16 hours"
    )
  end

end

scheduler = Rufus::Scheduler.new

scheduler.cron '30 11 * * 1-5' do
  puts "Checking email at #{Time.now}"
  check
end

scheduler.cron '0 18 * * 1-5' do
  puts "Checking email at #{Time.now}"
  check
end

puts "Scheduler pending as of #{Time.now}"
scheduler.join
