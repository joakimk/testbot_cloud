require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper.rb'))

describe TestbotCloud::Cluster do

  describe "when calling start" do

    before do
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
                                        and_return(@compute = mock(Object))
      @compute.stub!(:servers).and_return(mock(Object))
    end

    it "should create servers based on config.yml" do
      @compute.servers.should_receive(:create).twice.with(:image_id => "ami-xxxx").
                       and_return(fog_server = mock(Object, :id => nil, :wait_for => nil))

      TestbotCloud::Server::Factory.should_receive(:create).twice.with(@compute, fog_server).
                                     and_return(server = mock(Object))
      server.should_receive(:bootstrap!).twice.and_return(true)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.start
    end

    it "should destroy the server if bootstrap fails" do
      @compute.servers.should_receive(:create).twice.with(:image_id => "ami-xxxx").
                       and_return(fog_server = mock(Object, :id => nil, :wait_for => nil))

      TestbotCloud::Server::Factory.should_receive(:create).twice.with(@compute, fog_server).
                                     and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(false)
      fog_server.should_receive(:destroy).twice

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.start
    end

    it "should retry server create if it fails with a socket error" do
      class OpenStructWithQuietId < OpenStruct; def id; end; end
      class SocketErrorFogServerCollection
        attr_reader :id

        def create(opts)
          unless @called_once
            @called_once = true
            raise Excon::Errors::SocketError.new(Exception.new)
          else
            return OpenStructWithQuietId.new
          end
        end
      end

      @compute.stub!(:servers).and_return(SocketErrorFogServerCollection.new)
        
      TestbotCloud::Server::Factory.should_receive(:create).twice.
                                    and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(true)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.start
    end

    it "should retry wait for ready if it fails with a socket error" do
      class SocketErrorFogServer
        attr_reader :id

        def wait_for
          unless @called_once
            @called_once = true
            raise Excon::Errors::SocketError.new(Exception.new)
          else
            return true
          end
        end
      end

      @compute.servers.should_receive(:create).twice.with(:image_id => "ami-xxxx").
                       and_return(fog_server = SocketErrorFogServer.new)

      TestbotCloud::Server::Factory.should_receive(:create).twice.with(@compute, fog_server).
                                    and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(true)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.start
    end

  end

  describe "when calling stop" do

    before do
       YAML.should_receive(:load_file).with("config.yml").and_return({
         "provider" => {
           "provider" => "AWS",
           "aws_access_key_id" => "KEY_ID"
         },
         "runner" => {},
         "runners" => 0
       });
      
      Fog::Compute.should_receive(:new).with({ :provider => "AWS",
                                                :aws_access_key_id => "KEY_ID" }).
                                         and_return(@compute = mock(Object))
    end

    it "should stop servers that are ready" do
      @compute.stub!(:servers).and_return([ mock(Object, :ready? => false), 
                                            server = mock(Object, :ready? => true, :id => nil) ])
      server.should_receive(:destroy)
      
      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stop
    end

    it "should retry"

  end

end
