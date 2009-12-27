require 'vendor/gems/environment'
require 'mq'
require 'tweetstream'

username = ARGV.shift
password = ARGV.shift
raise "need username and password" if !username or !password

AMQP.start(:host => 'localhost') do
  twitter = MQ.new.fanout('twitter')

  Thread.new do
    TweetStream::Client.new(username, password).track('iphone') do |status|
      t = { 
        :id => status[:id],
        :username => status.user.screen_name,
        :text => status.text,
        :profile_image_url => status.user.profile_image_url
      }
      puts status.text
      twitter.publish(Marshal.dump(t))
    end
  end
end