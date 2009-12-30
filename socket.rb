require 'vendor/gems/environment'
require 'em-websocket'
require 'uuid'
require 'mq'

uuid = UUID.new

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    puts "WebSocket opened"

    twitter = MQ.new
    twitter.queue(uuid.generate).bind(twitter.fanout('twitter')).subscribe do |t|
      ws.send t
    end
  end

  ws.onclose do
    puts "WebSocket closed"
  end
end
