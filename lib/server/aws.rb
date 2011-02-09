module TestbotCloud
  module Server
    class AWS
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!(mutex)
        true
      end
    end
  end
end
