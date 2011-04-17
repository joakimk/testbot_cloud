require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper.rb'))

describe TestbotCloud::Cluster do

  describe "when not in a project" do

    it "should do nothing if there is no config.yml file" do
      File.should_receive(:exists?).any_number_of_times.with("config.yml").and_return(false)
      cluster = TestbotCloud::Cluster.new
      cluster.start
      cluster.stop
    end

  end

  describe "when calling start" do

    before do
      File.stub!(:exists?).with("config.yml").and_return(true)
      YAML.should_receive(:load_file).with("config.yml").and_return({
        "runners" => 2,
        "ssh_user" => "ubuntu",
        "provider" => {
          "provider" => "AWS",
          "aws_access_key_id" => "KEY_ID"
        },
        "runner" => {
          "image_id" => "ami-xxxx"
        }  
      });

      FileUtils.stub!(:mkdir_p)
      Fog::Compute.should_receive(:new).with({ :provider => "AWS",
                                               :aws_access_key_id => "KEY_ID" }).
                                        and_return(@compute = mock(Object))
      @compute.stub!(:servers).and_return(mock(Object))
    end

    it "should create servers based on config.yml" do
      @compute.servers.should_receive(:create).twice.with(:image_id => "ami-xxxx").
                       and_return(fog_server = mock(Object, :id => nil, :wait_for => nil))

      TestbotCloud::Server::Factory.should_receive(:create).twice.with(@compute, { :ssh_user => 'ubuntu' }, fog_server).
                                     and_return(server = mock(Object))
      server.should_receive(:bootstrap!).twice.and_return(true)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.start
    end

    it "should log the servers that are created" do
      @compute.servers.stub!(:create).and_return(mock(Object, :id => "srv-boo", :wait_for => nil),
                                                 mock(Object, :id => "srv-doo", :wait_for => nil))

      TestbotCloud::Server::Factory.should_receive(:create).twice.and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(true)

      FileUtils.should_receive(:mkdir_p).with(".servers/srv-boo")
      FileUtils.should_receive(:mkdir_p).with(".servers/srv-doo")

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.start
    end

    it "should destroy the server if bootstrap fails" do
      @compute.servers.stub!(:create).and_return(fog_server0 = mock(Object, :id => "srv-boo", :wait_for => nil),
                                                 fog_server1 = mock(Object, :id => "srv-moo", :wait_for => nil))

      TestbotCloud::Server::Factory.should_receive(:create).twice.and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(false)

      FileUtils.should_receive(:rm_rf).with(".servers/srv-moo")
      FileUtils.should_receive(:rm_rf).with(".servers/srv-boo")

      fog_server0.should_receive(:destroy)
      fog_server1.should_receive(:destroy)

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

      @compute.servers.stub!(:create).and_return(fog_server = SocketErrorFogServer.new)

      TestbotCloud::Server::Factory.should_receive(:create).twice.with(@compute,
                                    { :ssh_user => "ubuntu" }, fog_server).
                                    and_return(server = mock(Object))
      server.stub!(:bootstrap!).and_return(true)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.start
    end

    it "should retry bootstrap if it fails with a socket error" do
      @compute.servers.stub!(:create).and_return(mock(Object, :id => nil, :wait_for => nil))

      class SocketErrorServer
        def bootstrap!(mutex) 
          unless @called_once
            @called_once = true
            raise Excon::Errors::SocketError.new(Exception.new)
          else
            return true
          end
        end
      end

      TestbotCloud::Server::Factory.stub!(:create).and_return(SocketErrorServer.new)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.start
    end

  end

  describe "when calling stop" do

    before do
      File.stub!(:exists?).with("config.yml").and_return(true)
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

    it "should stop servers that are listed in the log file and ready" do
      @compute.stub!(:servers).and_return([ mock(Object, :ready? => false, :id => "srv-boo"), 
                                            server = mock(Object, :ready? => true, :id => "srv-moo"),
                                            unrelated_server = mock(Object, :ready? => true, :id => "srv-ahh") ])

      File.should_receive(:exists?).with(".servers/srv-boo").and_return(true)
      File.should_receive(:exists?).with(".servers/srv-moo").and_return(true)
      File.should_receive(:exists?).with(".servers/srv-ahh").and_return(false)
      FileUtils.should_receive(:rm_rf).with(".servers/srv-moo")
      server.should_receive(:destroy)

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stop
    end

    it "should retry destroy if it fails with a socket error" do
      class SocketErrorServer
        def id; "srv-moo"; end
        def ready?; true; end

        def destroy
          return if @called_once
          @called_once = true
          raise Excon::Errors::SocketError.new(Exception.new)
        end
      end

      @compute.stub!(:servers).and_return([ server = SocketErrorServer.new ]) 
                                            
      File.should_receive(:exists?).with(".servers/srv-moo").and_return(true)
      FileUtils.should_receive(:rm_rf).with(".servers/srv-moo")

      cluster = TestbotCloud::Cluster.new
      cluster.stub!(:puts)
      cluster.stub!(:sleep)
      cluster.stop
    end

  end

end
