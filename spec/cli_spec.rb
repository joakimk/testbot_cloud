require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper.rb'))

describe TestbotCloud::Cli do

  it "should include Thor::Actions" do
    TestbotCloud::Cli.included_modules.should include(Thor::Actions)
  end

  it "should set source_root to lib/providers/templates" do
    TestbotCloud::Cli.source_root.should include("lib/providers/templates")
  end

  describe "when calling new with a project name" do

    it "should generate a project using EC2 by default" do
      cli = TestbotCloud::Cli.new

      TestbotCloud::Providers::Ec2.should_receive(:new).with(cli).and_return(mock_ec2 = mock(Object))
      mock_ec2.should_receive(:generate_project).with("app_name")

      cli.new("app_name")
    end

  end

end
