require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::AWS, "bootstrap!" do

  it "should run bootstrap" do
    fog_server = mock(:dns_name => "example.com", :id => "i-500")

    TestbotCloud::Server::Bootstrap.should_receive(:new).with("example.com", "i-500",
                                                              :ssh_opts => "-i testbot.pem").
                                                              and_return(bootstrap = mock)
    bootstrap.should_receive(:install)
    server = TestbotCloud::Server::AWS.new(nil, fog_server)
    server.bootstrap!(nil)
  end

end

