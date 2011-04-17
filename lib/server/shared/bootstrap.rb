module TestbotCloud
  module Server
    class Bootstrap
      def initialize(host, id, opts)
        @host, @id, @opts = host, id, opts
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
        run_with_debug("scp #{ssh_opts("-r bootstrap")}:~ &> /dev/null")
      end

      def run(command)
        run_with_debug("ssh #{ssh_opts} '#{command}' &> /dev/null")
      end

      def run_with_debug(cmd)
        if ENV["DEBUG"]
          puts "DEBUG - CMD: #{cmd}"
          return_status = system(cmd.gsub(/&.+/, ''))
          puts "DEBUG - SUCCESS: #{return_status}"
          return_status
        else
          system(cmd)
        end
      end

      def ssh_opts(custom_opts = nil)
        [ "-o StrictHostKeyChecking=no", @opts[:ssh_opts],
           custom_opts, "#{@opts[:ssh_user]}@#{@host}" ].compact.join(' ')
      end  
    end
  end
end

