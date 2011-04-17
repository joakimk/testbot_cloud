require File.expand_path(File.join(File.dirname(__FILE__), 'shared', 'bootstrap.rb'))

module TestbotCloud
  module Server
    class AWS
      def initialize(compute, server)
        @server = server
      end

      def bootstrap!(mutex)
        return true if ENV['INTEGRATION_TEST']
        Bootstrap.new(@server.dns_name, @server.id, :ssh_opts => "-i testbot.pem").install
      end
    end
  end
end

