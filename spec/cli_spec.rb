require File.expand_path(File.join(File.dirname(__FILE__), '../lib/cli.rb'))
require 'minitest/autorun'

describe TestbotCloud::Cli do

  describe "when calling new with a project name" do

    before do
      system "rm -rf tmp"
    end

    it "should generate a project" do
      cli = TestbotCloud::Cli.new
      cli.new('tmp/app_name')
      File.exists?("tmp/app_name/config.yml").must_equal true
      File.exists?("tmp/app_name/ec2_key.pem").must_equal true
    end

  end

end
