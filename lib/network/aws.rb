module TestbotCloud
  module Network
    class AWS
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!
      end

      def running?
      end
    end
  end
end
