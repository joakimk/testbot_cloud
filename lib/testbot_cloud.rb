require File.expand_path(File.join(File.dirname(__FILE__), 'cli.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'providers/ec2.rb'))

TestbotCloud::Cli.providers = { :ec2 => TestbotCloud::Providers::Ec2 }

module TestbotCloud
  DEFAULT_PROVIDER = :ec2
end

