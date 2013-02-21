require 'miu/plugin'

module Miu
  module Plugins
    class Pannya
      include Miu::Plugin

      class Handler
        def log(tag, time, record)
          p [tag, time, record]
          'OK'
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
        @server.listen host, port, Handler.new

        [:TERM, :INT].each do |sig|
          Signal.trap(sig) { @server.stop }
        end

        @server.run
      end

      register :sana, :desc => %(miu groonga plugin 'sana') do
        desc 'start', %(start sana)
        option :bind, :type => :string, :default => '127.0.0.1', :desc => 'bind address', :aliases => '-a'
        option :port, :type => :numeric, :default => 30303, :desc => 'listen port', :aliases => '-p'
        def start
          Pannya.new options
        end

        desc 'init', %(init sana config)
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