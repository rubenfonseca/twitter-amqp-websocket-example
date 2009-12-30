require 'vendor/gems/environment'
require 'em-websocket'
require 'mq'

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    puts "WebSocket opened"

    twitter = MQ.new

    # randomize the queue name that binds to the fanout exchange so every
    # websocket client (or clients that reload) get their own queue.
    twitter.queue(rand(65000).to_s).bind(twitter.fanout('twitter')).subscribe do |t|
      ws.send t
    end
  end

  ws.onclose do
    puts "WebSocket closed"
  end
end
