require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::AWS, "bootstrap!" do

  it "should upload bootstrap files and run them" do
    fog_server = mock(Object, :dns_name => "server.somewhere.ec2", :id => "i-aaa")
    server = TestbotCloud::Server::AWS.new(nil, fog_server)
    
    server.should_receive(:system).and_return(true)
    server.should_receive(:system).with("scp -o StrictHostKeyChecking=no -i testbot.pem -r bootstrap ubuntu@server.somewhere.ec2:~ &> /dev/null").and_return(true)
    server.should_receive(:system).with("ssh -o StrictHostKeyChecking=no -i testbot.pem ubuntu@server.somewhere.ec2 'cd bootstrap; sudo sh runner.sh' &> /dev/null")

    server.stub!(:sleep)
    server.bootstrap!(Mutex.new)
  end

end

