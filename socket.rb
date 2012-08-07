require 'em-websocket'
require 'uuid'
require 'amqp'

uuid = UUID.new

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    puts "WebSocket opened"
    AMQP.connect(:host => '127.0.0.1') do |connection, open_ok|
      AMQP::Channel.new(connection) do |channel, open_ok|
        channel.queue(uuid.generate, :auto_delete => true).bind(channel.fanout("twitter")).subscribe do |t|
          puts 'got a tweet'
          ws.send t
        end
      end
    end
  end

  ws.onclose do
    puts "WebSocket closed"
  end
end
