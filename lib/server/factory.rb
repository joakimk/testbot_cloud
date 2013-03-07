begin
  require 'fog/compute/models/brightbox/server'
  require 'fog/compute/models/aws/server'
  require 'fog/compute/models/bluebox/server'
rescue LoadError
  # New style paths in fog master
  require 'fog/brightbox/models/compute/server'
  require 'fog/aws/models/compute/server'
  require 'fog/bluebox/models/compute/server'
end

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
