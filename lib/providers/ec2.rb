module TestbotCloud
  module Providers
    class Ec2
      def initialize(generator)
        @generator = generator
      end

      def generate_project(name)
        @generator.copy_file "ec2/config.yml", "#{name}/config.yml"
        @generator.copy_file "ec2/ssh_key.pem", "#{name}/ssh_key.pem"
      end
    end
  end
end
