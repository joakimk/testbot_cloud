module TestbotCloud
  module Server
    class Brightbox
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!(mutex)
        ip = nil
        mutex.synchronize { ip = map_ip! }

        unless ENV['INTEGRATION_TEST']
          if online?(ip)
            return system("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@#{ip.public_ip}:~ &> /dev/null") &&
                   system("ssh -o StrictHostKeyChecking=no ubuntu@#{ip.public_ip} 'cd bootstrap; sudo sh runner.sh' &> /dev/null")
          end
        else
          return true
        end

        false
      end

      private

      def online?(ip)
        # Wait a while, seems the server gets the ssh key some time after being ready.
        sleep 5

        10.times do
          if system("ssh -o StrictHostKeyChecking=no ubuntu@#{ip.public_ip} 'true' &> /dev/null")
            return true
          else
            puts "#{@server.id} ssh connection failed, retrying..."
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


