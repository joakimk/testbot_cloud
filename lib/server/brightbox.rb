module TestbotCloud
  module Server
    class Brightbox
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!(mutex)
        ip = nil
        mutex.synchronize { ip = map_ip! }
        Bootstrap.new(ip.public_ip, @server.id).install
      end

      private

      def map_ip!
        ip = get_ip
        ip.map(@server.interfaces.first["id"])
        ip
      end

      def get_ip
        if available_ip = find_available_ip 
          available_ip
        else
          @compute.create_cloud_ip
          find_available_ip
        end
      end

      def find_available_ip
        @compute.cloud_ips.find { |ip| ip.status == "unmapped" }
      end
    end
  end
end


