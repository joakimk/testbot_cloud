require File.expand_path(File.join(File.dirname(__FILE__), '../lib/cli.rb'))
require 'minitest/autorun'

describe TestbotCloud::Cli do

  describe "when calling new with a project name" do

    it "should include Thor::Actions" do
      TestbotCloud::Cli.must_include Thor::Actions
    end

    it "should generate a project using EC2 by default" do
      mock_ec2_klass = MiniTest::Mock.new
      mock_ec2 = MiniTest::Mock.new
      
      cli = TestbotCloud::Cli.new
      mock_ec2_klass.expect :new, mock_ec2, [ cli ]
      mock_ec2.expect :generate_project, nil, [ "app_name" ]

      TestbotCloud::Cli.providers = { :ec2 => mock_ec2_klass }
      cli.new("app_name")
      mock_ec2.verify
    end

    it "should set source_root to lib/providers/templates" do
      TestbotCloud::Cli.source_root.must_include "lib/providers/templates"
    end

  end

end
