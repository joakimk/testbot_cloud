require File.expand_path(File.join(File.dirname(__FILE__), 'shared', 'bootstrap.rb'))

module TestbotCloud
  module Server
    class AWS
      def initialize(compute, server)
        @compute, @server = compute, server
        @bootstrap = Bootstrap.new(server.dns_name, server.id, :ssh_opts => "-i testbot.pem")
      end

      # Refactoring step
      attr_reader :bootstrap

      def bootstrap!(mutex)
        return true if ENV['INTEGRATION_TEST']
        @bootstrap.install
      end
    end
  end
end

