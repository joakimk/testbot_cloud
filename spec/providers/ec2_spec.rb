require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Providers::Ec2 do

  describe "generate_project" do

    it "should use a generator to copy config and bootstrap files" do
      mock_generator = Object.new

      mock_generator.should_receive(:copy_file).with("ec2/provider", "demo/.provider")
      mock_generator.should_receive(:copy_file).with("ec2/config.yml", "demo/config.yml")
      mock_generator.should_receive(:copy_file).with("ec2/ssh_key.pem", "demo/ssh_key.pem") 
      mock_generator.should_receive(:copy_file).with("shared/ubuntu/server.sh", "demo/bootstrap/server.sh") 
      mock_generator.should_receive(:copy_file).with("shared/ubuntu/runner.sh", "demo/bootstrap/runner.sh") 
      mock_generator.should_receive(:copy_file).with("shared/ubuntu/shared.sh", "demo/bootstrap/shared.sh") 
      provider = TestbotCloud::Providers::Ec2.new(mock_generator)
      provider.generate_project("demo")
    end

  end

end

