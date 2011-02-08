require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::Factory do
  
  it "should create a server wrapper for Brightbox" do
    server = TestbotCloud::Server::Factory.create(nil, Fog::Brightbox::Compute::Server.new)
    server.should be_instance_of(TestbotCloud::Server::Brightbox)
  end

  it "should create a server wrapper for AWS" do
    server = TestbotCloud::Server::Factory.create(nil, Fog::AWS::Compute::Server.new)
    server.should be_instance_of(TestbotCloud::Server::AWS)
  end

  it "should raise an error when there is no server wrapper" do
    expect {
      TestbotCloud::Server::Factory.create(nil, Fog::Slicehost::Compute::Server.new)
    }.to raise_error(/Unsupported server type: /)
  end


end
