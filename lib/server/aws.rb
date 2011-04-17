require File.expand_path(File.join(File.dirname(__FILE__), 'shared', 'bootstrap.rb'))

module TestbotCloud
  module Server
    class AWS
      def initialize(compute, opts, server)
        @server, @opts = server, opts
      end

      def bootstrap!(mutex)
        # We use the AWS adapter in integration tests.
        return true if ENV['INTEGRATION_TEST']

        Bootstrap.new(@server.dns_name, @server.id, @opts.merge({ :ssh_opts => "-i testbot.pem" })).install
      end
    end
  end
end

