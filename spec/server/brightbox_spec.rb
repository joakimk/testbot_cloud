require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::Brightbox, "bootstrap!" do

  it "should find unmapped ips and map to the server" do
    compute = mock(Object, :cloud_ips => [ mock(Object, :status => "mapped"), available_ip = mock(Object, :status => "unmapped", :public_ip => nil) ])
    fog_server = mock(Object, :interfaces => [ { "id" => "int-xxyyy" } ])
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    available_ip.should_receive(:map).with("int-xxyyy")
    server.stub!(:system).and_return(true)
    server.stub!(:sleep)

    server.bootstrap!
  end

  it "should create a cloud ip and map when none are available" do
    # Found no good way to assert the order of events other than creating a custom mock class.
    class ComputeWithNoFreeIps
      def initialize; @cloud_ips = []; end
      attr_reader :cloud_ips

      def create_cloud_ip
        @cloud_ips << OpenStruct.new(:status => "unmapped")
        @cloud_ips.last.should_receive(:map).with("int-xxyyy")
      end
    end

    compute = ComputeWithNoFreeIps.new
    fog_server = mock(Object, :interfaces => [ { "id" => "int-xxyyy" } ])
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    server.stub!(:system).and_return(true)
    server.stub!(:sleep)
    server.bootstrap!
  end

  it "should upload bootstrap files and run them" do
    compute = mock(Object, :cloud_ips => [ mock(Object, :status => "unmapped",
                                                        :map => nil,
                                                        :public_ip => "15.14.13.12") ])
    fog_server = mock(Object, :interfaces => [{}], :id => nil)
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    server.should_receive(:system).and_return(true)
    server.should_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~")
    server.should_receive(:system).with("ssh -o StrictHostKeyChecking=no ubuntu@15.14.13.12 'cd bootstrap; sudo sh runner.sh'")

    server.stub!(:sleep)
    server.bootstrap!
  end


  it "should try to get a connection going before running bootstrap" do
    compute = mock(Object, :cloud_ips => [ mock(Object, :status => "unmapped",
                                                        :map => nil,
                                                        :public_ip => "15.14.13.12") ])
    fog_server = mock(Object, :interfaces => [{}], :id => nil)
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    server.should_receive(:system).and_return(false)
    server.should_receive(:system).and_return(false)
    server.should_receive(:system).and_return(true)
    server.should_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~")
    server.should_receive(:system).with("ssh -o StrictHostKeyChecking=no ubuntu@15.14.13.12 'cd bootstrap; sudo sh runner.sh'")

    server.should_receive(:sleep).twice.with(3)
    server.stub!(:puts)
    server.bootstrap!
  end

  it "should not try to bootstrap if the connection fails" do
    compute = mock(Object, :cloud_ips => [ mock(Object, :status => "unmapped",
                                                        :map => nil,
                                                        :public_ip => "15.14.13.12") ])
    fog_server = mock(Object, :interfaces => [{}], :id => nil)
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    server.stub!(:system).and_return(false)
    server.should_not_receive(:system).with("scp -o StrictHostKeyChecking=no -r bootstrap ubuntu@15.14.13.12:~")

    server.stub!(:sleep)
    server.stub!(:puts)
    server.bootstrap!
  end

end
