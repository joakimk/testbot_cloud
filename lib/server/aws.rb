module TestbotCloud
  module Server
    class AWS
      def initialize(compute, server)
        @compute, @server = compute, server
      end

      def bootstrap!(mutex)
        unless ENV['INTEGRATION_TEST']
          if online?(@server.dns_name)
            return system("scp -o StrictHostKeyChecking=no -i testbot.pem -r bootstrap ubuntu@#{@server.dns_name}:~ &> /dev/null") &&
                   system("ssh -o StrictHostKeyChecking=no -i testbot.pem ubuntu@#{@server.dns_name} 'cd bootstrap; sudo sh runner.sh' &> /dev/null")
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
          if system("ssh -o StrictHostKeyChecking=no -i testbot.pem ubuntu@#{ip} 'true' &> /dev/null")
            return true
          else
            puts "#{@server.id} ssh connection failed, retrying..."
            sleep 3
          end
        end

        false
      end      
    end
  end
end
