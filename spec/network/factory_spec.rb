require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Network::Factory do
  
  it "should create a network mapper for Brightbox" do
    network = TestbotCloud::Network::Factory.create(nil, Fog::Brightbox::Compute::Server.new)
    network.should be_instance_of(TestbotCloud::Network::Brightbox)
  end

  it "should create a network mapper for AWS" do
    network = TestbotCloud::Network::Factory.create(nil, Fog::AWS::Compute::Server.new)
    network.should be_instance_of(TestbotCloud::Network::AWS)
  end

  it "should raise an error when there is no network mapper" do
    expect {
      TestbotCloud::Network::Factory.create(nil, Fog::Slicehost::Compute::Server.new)
    }.to raise_error(/Unsupported server type: /)
  end


end
