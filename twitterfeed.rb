require 'amqp'
require 'twitter/json_stream'

username = ARGV.shift
password = ARGV.shift
raise "need username and password" if !username or !password

AMQP.start(:host => 'localhost') do |connection, open_ok|
  AMQP::Channel.new(connection) do |channel, open_ok|
    twitter = channel.fanout("twitter")

    stream = Twitter::JSONStream.connect(
      :path => '/1/statuses/filter.json?track=iphone',
      :auth => "#{username}:#{password}"
    )

    stream.each_item do |status|
      twitter.publish(status)
    end
  end
end
