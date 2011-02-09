module TestbotCloud
  module Server
    class Brightbox
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!
        ip = map_ip!
        unless ENV['INTEGRATION_TEST']
          if online?(ip)
            system "scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@#{ip.public_ip}:~"
            system "ssh -o StrictHostKeyChecking=no ubuntu@#{ip.public_ip} 'cd bootstrap; sudo sh runner.sh'"
          end
        end
      end

      private

      def online?(ip)
        10.times do
          if system "ssh -o StrictHostKeyChecking=no ubuntu@#{ip.public_ip} 'true' &> /dev/null"
            return true
          else
            puts "Connection failed for server #{@server.id} @ #{ip.public_ip}, retrying..."
            sleep 3
          end
        end

        false
      end

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


