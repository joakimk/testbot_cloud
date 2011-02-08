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

  describe "when calling start" do

    it "should create servers based on config.yml" do
      YAML.should_receive(:load_file).with("config.yml").and_return({
        "runners" => 2,
        "provider" => {
          "provider" => "AWS",
          "aws_access_key_id" => "KEY_ID"
        },
        "runner" => {
          "image_id" => "ami-xxxx"
        }  
      });

      Fog::Compute.should_receive(:new).with({ :provider => "AWS",
                                               :aws_access_key_id => "KEY_ID" }).
                                        and_return(compute = mock(Object))
      compute.stub!(:servers).and_return(servers = mock(Object))
      compute.servers.should_receive(:create).twice.with(:image_id => "ami-xxxx").
                      and_return(server = mock(Object, :id => nil, :wait_for => nil))

      TestbotCloud::Network::Factory.should_receive(:create).twice.with(compute, server).
                                     and_return(network = mock(Object))
      network.should_receive(:bootstrap!).twice

      cli = TestbotCloud::Cli.new
      cli.stub!(:puts)
      cli.start
    end

  end

end
