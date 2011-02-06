module TestbotCloud
  module Providers
    class Ec2
      def initialize(generator)
        @generator = generator
      end

      def generate_project(name)
        @generator.copy_file "ec2/provider", "#{name}/.provider"
        @generator.copy_file "ec2/config.yml", "#{name}/config.yml"
        @generator.copy_file "ec2/ssh_key.pem", "#{name}/ssh_key.pem"
        @generator.copy_file "shared/ubuntu/server.sh", "#{name}/bootstrap/server.sh"
        @generator.copy_file "shared/ubuntu/runner.sh", "#{name}/bootstrap/runner.sh"
        @generator.copy_file "shared/ubuntu/shared.sh", "#{name}/bootstrap/shared.sh"
      end
    end
  end
end
