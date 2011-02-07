require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper.rb'))

describe TestbotCloud::Cli do

  it "should include Thor::Actions" do
    TestbotCloud::Cli.included_modules.should include(Thor::Actions)
  end

  it "should set source_root to lib/templates" do
    TestbotCloud::Cli.source_root.should include("lib/templates")
  end

  describe "when calling new with a project name" do

    it "should generate a project" do
      cli = TestbotCloud::Cli.new
      cli.should_receive(:copy_file).with("config.yml", "app_name/config.yml")
      cli.should_receive(:copy_file).with("runner.sh", "app_name/bootstrap/runner.sh") 
      cli.new("app_name")
    end

  end

end
