require 'miu/plugin'
require 'json'
require 'thin'
require 'rack'
require 'rack/websocket'
require 'em-websocket'

module Miu
  module Plugins
    class Pannya
      include Miu::Plugin

      class MessageEmitter
        def initialize(channel)
          @channel = channel
        end

        def log(tag, time, record)
          p [tag, time, record]
          record = {:tag => tag, :time => time, :miu => record}
          @channel.push record.to_json
          #emit_message!(tag, time, record)
        end

        def emit_message(tag, time, record)
          p [tag, time, record]
          #publish 'message_receive' , {:tag => tag, :time => time, :miu => JSON.parse(record)}
        end
      end

      def initialize(options)
        require 'msgpack/rpc'
        run options
      end

      private

      def run(options)
        host = options[:host]
        port = options[:port]
        puts "run1"

        @channel = EventMachine::Channel.new

        @server = MessagePack::RPC::Server.new
        @server.listen host, port, MessageEmitter.new(@channel)
        puts "run2"
        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { @server.stop }
        end
        puts "run3"
        @msgpack_thread = Thread.new(@server) do |server|
          server.run
        end
        puts "run4"


        EM.run do
          EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080) do |ws|
            ws.onopen {
              sid = @channel.subscribe { |msg| ws.send msg }
              #@channel.push "#{sid} connected!"

              ws.onmessage { |msg|
                puts msg
                #@channel.push "<#{sid}>: #{msg}"
              }

              ws.onclose {
                @channel.unsubscribe(sid)
              }

              puts "Connected!"
            }
          end
        end
        puts "runned"
      end

      register :pannya, :desc => %(miu log viewer plugin 'pannya') do
        desc 'start', %(start pannya)
        option :bind, :type => :string, :default => '127.0.0.1', :desc => 'msgpack-rpc bind address', :aliases => '-a'
        option :port, :type => :numeric, :default => 30303, :desc => 'msgpack-rpc listen port', :aliases => '-p'
        def start
          Pannya.new options
        end

        desc 'init', %(init pannya config)
        option :bind, :type => :string, :default => '127.0.0.1', :desc => 'msgpack-rpc bind address', :aliases => '-a'
        option :port, :type => :numeric, :default => 30303, :desc => 'msgpack-rpc listen port', :aliases => '-p'
        def init
          append_to_file 'config/miu.god', <<-CONF

God.watch do |w|
  w.dir = Miu.root
  w.log = Miu.root.join('log/pannya.log')
  w.name = 'pannya'
  w.start = 'bundle exec miu pannya start'
  w.keepalive
end
          CONF
          append_to_file 'config/fluent.conf', <<-CONF

# miu null output plugin
<match miu.output.**>
  type msgpack_rpc
  host localhost
  port 30303
</match>
          CONF
        end
      end
    end
  end
end