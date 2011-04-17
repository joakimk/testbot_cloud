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
      cli.should_receive(:copy_file).with("gitignore", "app_name/.gitignore")
      cli.should_receive(:copy_file).with("runner.sh", "app_name/bootstrap/runner.sh") 
      cli.new("app_name")
    end

  end

  describe "when calling start" do
    
    it "should start a cluster" do
      TestbotCloud::Cluster.stub!(:new).and_return(cluster = mock(Object))
      cluster.should_receive(:start)
      TestbotCloud::Cli.new.start
    end

  end

  describe "when calling stop" do

    it "should stop a cluster" do
      TestbotCloud::Cluster.stub!(:new).and_return(cluster = mock(Object))
      cluster.should_receive(:stop)
      TestbotCloud::Cli.new.stop
    end

  end

  describe "when calling version" do

    it "should print the version" do
      cli = TestbotCloud::Cli.new
      cli.should_receive(:puts).with("TestbotCloud #{TestbotCloud::VERSION}")
      cli.version
    end

  end

end

