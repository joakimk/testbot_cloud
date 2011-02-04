require File.expand_path(File.join(File.dirname(__FILE__), '../lib/cli.rb'))
require 'minitest/autorun'

describe TestbotCloud::Cli do

  describe "when calling new with a project name" do

    before do
      system "rm -rf tmp"
    end

    it "should include Thor::Actions" do
      TestbotCloud::Cli.must_include Thor::Actions
    end

    it "should generate a project using EC2 by default" do
      mock_ec2 = MiniTest::Mock.new
      mock_ec2.expect :generate_project, nil, [ "app_name" ]
      cli = TestbotCloud::Cli.new
      cli.providers = { :ec2 => mock_ec2 }
      cli.new("app_name")
      mock_ec2.verify
    end

    it "should set source_root to lib/providers/templates" do
      TestbotCloud::Cli.source_root.must_include "lib/providers/templates"
    end

    it "should generate a project" do
      cli = TestbotCloud::Cli.new
      cli.providers = { :ec2 => TestbotCloud::Providers::Ec2.new(cli) }
      cli.new('tmp/app_name')
      File.exists?("tmp/app_name/config.yml").must_equal true
      File.exists?("tmp/app_name/ssh_key.pem").must_equal true
    end

  end

end
