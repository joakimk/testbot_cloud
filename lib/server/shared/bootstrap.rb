module TestbotCloud
  module Server
    class Bootstrap
      def initialize(host, id, opts = {})
        @host, @id = host, id
        @opts = { :user => "ubuntu" }.merge(opts)
      end

      def install
        wait_for_server && upload_bootstrap_files && run('cd bootstrap; sudo sh runner.sh')
      end

      private
      
      def wait_for_server
        fail_count = 0
        10.times do
          if run('true')
            return true
          else
            fail_count += 1
            
            # Usally fails atleast once, so better to keep it quiet to begin with
            if fail_count > 2
              puts "#{@id} ssh connection failed, retrying..."
            end

            sleep 3
          end
        end

        false
      end

      def upload_bootstrap_files
        system("scp -r bootstrap #{ssh_opts}:~ &> /dev/null")
      end

      def run(command)
        system("ssh #{ssh_opts} '#{command}' &> /dev/null")
      end

      def ssh_opts
        [ "-o StrictHostKeyChecking=no", @opts[:ssh_opts], "#{@opts[:user]}@#{@host}" ].compact.join(' ')
      end  
    end
  end
end

