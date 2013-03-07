require 'miu/plugin'
require 'json'
require 'reel'

module Miu
  module Plugins
    class Pannya
      include Miu::Plugin

      class WebSocketHandler
        include Celluloid
        include Celluloid::Notifications
        include Celluloid::Logger

        def initialize(web_socket)
          @ws = web_socket
          subscribe('message_receive', :on_message)
        end

        def on_message(message)
          @ws << message.to_json
        end
      end


      class MessageEmitter
        include Celluloid
        include Celluloid::Notifications

        def initialize
        end

        def log(tag, time, record)
          p [tag, time, record]
          emit_message!(tag, time, record)
        end

        def emit_message(tag, time, record)
          p [tag, time, record]
          publish 'message_receive' , {:tag => tag, :time => time, :miu => JSON.parse(record)}
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

        @server = MessagePack::RPC::Server.new
        @server.listen host, port, MessageEmitter.new

        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { @server.stop }
        end

        @server.run

        @websocket = nil
      end

      register :pannya, :desc => %(miu groonga plugin 'pannya') do
        desc 'start', %(start pannya)
        option :bind, :type => :string, :default => '127.0.0.1', :desc => 'bind address', :aliases => '-a'
        option :port, :type => :numeric, :default => 30303, :desc => 'listen port', :aliases => '-p'
        def start
          Pannya.new options
        end

        desc 'init', %(init pannya config)
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