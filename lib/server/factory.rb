require 'fog/compute/models/slicehost/server'
require 'fog/compute/models/brightbox/server'
require 'fog/compute/models/aws/server'
require File.expand_path(File.join(File.dirname(__FILE__), 'brightbox.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'aws.rb'))

module TestbotCloud
  module Server
    class Factory
      def self.create(compute, opts, server)
        if server.is_a?(Fog::Brightbox::Compute::Server)
          Brightbox.new(compute, opts, server)
        elsif server.is_a?(Fog::AWS::Compute::Server)
          AWS.new(compute, opts, server)
        else
          raise "Unsupported server type: #{server}"
        end
      end
    end
  end
end
