require 'vendor/gems/environment'
require 'mq'
require 'twitter/json_stream'

username = ARGV.shift
password = ARGV.shift
raise "need username and password" if !username or !password

AMQP.start(:host => 'localhost') do
  twitter = MQ.new.fanout('twitter')
  
  stream = Twitter::JSONStream.connect(
    :path => '/1/statuses/filter.json?track=iphone',
    :auth => "#{username}:#{password}"
  )
  
  stream.each_item do |status|
    twitter.publish(status)
  end
end